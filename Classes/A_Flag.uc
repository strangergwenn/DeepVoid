/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class A_Flag extends UDKCarriedObject
	notplaceable;


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (Flag) const color					RedTeamColor;
var (Flag) const color					BlueTeamColor;
var (Flag) const float					AutoReturnTime;

var (Flag) const array<MaterialInstanceConstant> TeamMaterials;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var repnotify P_Pawn					Holder;

var LinearColor							MaterialLight;
var repnotify color						LightColor;
var PointLightComponent 				FlagLight;

var StaticMeshComponent					Mesh;

var MaterialInstanceConstant			TeamMaterial;

var byte 								TeamIndex;

var bool								bCarried;
var bool								bIsReturnable;

var float								DefaultRadius;
var float								DefaultHeight;


/*----------------------------------------------------------
	Replication
----------------------------------------------------------*/

replication
{
	if (bNetDirty)
		Holder, TeamIndex, bCarried, bIsReturnable, LightColor;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'LightColor')
	{
		ClientSetFlagData();
		return;
	}
	if (VarName == 'Holder' && Holder != None)
	{
		AttachFlag(Holder);
		return;
	}
}


/*----------------------------------------------------------
	Spawn and network methods
----------------------------------------------------------*/

/*--- Startup ---*/
function PostBeginPlay()
{
    SetOwner(None);
    super.PostBeginPlay();

	if (CylinderComponent(CollisionComponent) != None)
	{
		DefaultRadius = CylinderComponent(CollisionComponent).CollisionRadius;
		DefaultHeight = CylinderComponent(CollisionComponent).CollisionHeight;
	}

	bCarried = false;
	bIsReturnable = false;
}


/*--- Set the flag data server-side ---*/
reliable server simulated function SetFlagData(byte Index, A_FlagBase FlagParent)
{
	`log("AF > SetFlagData" @self);
	TeamIndex = Index;
	HomeBase = FlagParent;
	LightColor = (TeamIndex == 0) ? RedTeamColor : BlueTeamColor;
	MaterialLight = ColorToLinearColor(LightColor);
	if (TeamMaterial != None && WorldInfo.NetMode == NM_Standalone)
	{
		TeamMaterial.SetVectorParameterValue('Light', MaterialLight);
		ClientSetFlagData();
	}
}


/*--- Set the flag data client-side---*/
reliable client simulated function ClientSetFlagData()
{
	`log("AF > ClientSetFlagData" @self);
	FlagLight.SetLightProperties(FlagLight.Brightness, LightColor);

	if (TeamMaterial != None)
	{
		MaterialLight = ColorToLinearColor(LightColor);
		TeamMaterial.SetVectorParameterValue('Light', MaterialLight);
	}

	if (TeamMaterials[TeamIndex] != None)
	{
		TeamMaterial = Mesh.CreateAndSetMaterialInstanceConstant(0);
		if (TeamMaterial != None)
		{
			TeamMaterial.SetParent(TeamMaterials[TeamIndex]);
		}
	}
}


/*----------------------------------------------------------
	Game methods
----------------------------------------------------------*/

/*--- Return the flag or retake it ---*/
event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local P_Pawn PP;
	if (P_Pawn(Other) != None)
	{
		PP = P_Pawn(Other);
		if (PP != Holder && PP.Controller.PlayerReplicationInfo != None)
		{
			// Flag on the ground
			if (bIsReturnable)
			{
				// Return
				if (TeamIndex == DVPlayerRepInfo(PP.Controller.PlayerReplicationInfo).Team.TeamIndex)
				{
					`log("AF > Returned" @self);
					A_FlagBase(HomeBase).FlagReturned();
					Destroy();
				}

				// Retake
				else
				{
					`log("AF > Retaken" @self);
					AttachFlag(PP);
				}

			}

			// Flag at base
			else if (!bCarried)
			{
				// Friendly touch : we could be capturing another flag
				if (TeamIndex == DVPlayerRepInfo(PP.PlayerReplicationInfo).Team.TeamIndex)
				{
					if (PP.HasFlag())
					{
						PP.CaptureFlag();
					}
					else
					{
						`log("AF > Neutral pawn" @self);
					}
				}

				// Enemy touch : take
				else
				{
					`log("AF > Flag take" @self);
					AttachFlag(PP);
				}
			}

			else
			{
				`log("AF > Neither returnable or at home" @self);
			}
		}
		else
		{
			`log("AF > Nott a valid PR pawn / same holder" @Holder @PP @self);
		}
	}
	else
	{
		`log("AF > Not a pawn" @self);
	}
}


/*--- This flag was captured ---*/
simulated function Captured()
{
	`log("AF > Captured" @self);
	A_FlagBase(HomeBase).FlagCaptured();
	SetBase(None);
	SkelMesh.DetachFromAny();
	Destroy();
}


/*--- Pawn tick ---*/
simulated function Tick(float DeltaTime)
{
	// Weapon adjustment
	if (Location.Z < WorldInfo.KillZ + 150.0)
	{
		`log("AF > Idiot just suicided with the flag" @self);
		A_FlagBase(HomeBase).FlagReturned();
		Destroy();
	}
	super.Tick(DeltaTime);
}


/*--- Set holder ---*/
simulated function SetHolder(P_Pawn NewHolder)
{
	Holder = NewHolder;
}


/*--- Get the flag ---*/
reliable server simulated function AttachFlag(P_Pawn PP)
{
	`log("AF > AttachFlag" @self);
	SetBase(PP);
	PP.EnemyFlag = self;
	SetHolder(PP);
	
	if (WorldInfo.NetMode == NM_DedicatedServer)
	{
		G_CaptureTheFlag(WorldInfo.Game).FlagTaken(TeamIndex);
	}

	bCarried = true;
	bIsReturnable = false;
	bForceNetUpdate = true;
}


/*--- Drop the flag ---*/
reliable server simulated function ServerDrop(Controller OldOwner)
{
	`log("AF > Drop" @self);
	ServerLogAction("FDROP");

	Holder = None;
	bCollideWorld = true;
	bForceNetUpdate = true;

	if (Holder != None)
	{
		Velocity = Holder.Velocity;
		if (Holder.Health > 0)
		{
			Velocity += 300 * vector(Holder.Rotation) + 100 * (0.5 + FRand()) * VRand();
		}
	}
	Velocity.Z = 300.0;

	SetBase(None);
	SetPhysics(PHYS_Falling);

	SetTimer(1.0, false, 'SetReturnable');
	SetTimer(AutoReturnTime, false, 'ReturnOnTimeOut');
}


/*-- Returnable ---*/
reliable server simulated function SetReturnable()
{
	bIsReturnable = true;
	Holder = None;
}


/*-- Return when dropped for too long ---*/
simulated function ReturnOnTimeOut()
{
	if (bIsReturnable)
	{
		`log("AF > ReturnOnTimeOut" @self);
		A_FlagBase(HomeBase).FlagReturned();
		Destroy();
	}
}


/*--- Standard log procedure ---*/
reliable server simulated function ServerLogAction(string event)
{
	if (Holder != None && (WorldInfo.NetMode == NM_DedicatedServer || WorldInfo.NetMode == NM_Standalone))
	{
		if (Holder.bDVLog)
		{
			`log("DVL/"
				$event 
				$"/" $self
				$"/X/" $Location.Y
				$"/Y/" $Location.X 
				$"/Z/" $Location.Z 
				$"/EDL"
			);
		}
	}
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultProperties
{
	// Networking
	Physics=PHYS_None
	RemoteRole=ROLE_SimulatedProxy
	bReplicateMovement=true
	bIgnoreRigidBodyPawns=true
	NetPriority=+00003.000000
	
	// Gameplay
	bAlwaysRelevant=true
	bHome=true
	bStatic=false
 	bHardAttach=true
	bCollideActors=true
	bBlockActors=false
	bIsReturnable=false
	AutoReturnTime=20.0
	RedTeamColor=(R=200,G=50,B=20)
	BlueTeamColor=(R=20,G=50,B=200)

	// Collisions
	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=+0048.000000
		CollisionHeight=+0085.000000
		CollideActors=true
	End Object

	// Ambient light
	Begin Object class=PointLightComponent name=FlagLightComponent
		Brightness=1.5
		LightColor=(R=10,G=255,B=0)
		Translation=(X=-40.0,Y=0.0,Z=-45.0)
		Radius=500.0
		bEnabled=true
		CastShadows=true
		bRenderLightShafts=false
		LightingChannels=(Dynamic=true,CompositeDynamic=true)
	End Object
	FlagLight=FlagLightComponent
	Components.Add(FlagLightComponent)

	// Lighting
	Begin Object Class=DynamicLightEnvironmentComponent Name=FlagLightEnvironment
	    bDynamic=false
	End Object
	Components.Add(FlagLightEnvironment)

	// Mesh
	Begin Object Class=StaticMeshComponent Name=TheFlagMesh
		BlockActors=false
		CollideActors=true
		BlockRigidBody=false
		scale=0.4
		Translation=(X=-40.0,Y=0.0,Z=-45.0)
		LightEnvironment=FlagLightEnvironment
		StaticMesh=StaticMesh'DV_Gameplay.Mesh.SM_Flag'
	End Object
	Mesh=TheFlagMesh;
	Components.Add(TheFlagMesh)
	CollisionComponent=TheFlagMesh

	// Materials
	TeamMaterials[0]=MaterialInstanceConstant'DV_Gameplay.Materials.MI_Flag_Red'
	TeamMaterials[1]=MaterialInstanceConstant'DV_Gameplay.Materials.MI_Flag_Blue'
}
