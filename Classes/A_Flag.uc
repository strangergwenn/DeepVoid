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


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var repnotify P_Pawn					Holder;

var repnotify color						LightColor;
var PointLightComponent 				FlagLight;

var byte 								TeamIndex;

var bool								bIsReturnable;

var float								DefaultRadius;
var float								DefaultHeight;


/*----------------------------------------------------------
	Replication
----------------------------------------------------------*/

replication
{
	if (bNetDirty)
		Holder, TeamIndex, bIsReturnable, LightColor;
}

simulated event ReplicatedEvent(name VarName)
{	
	// Weapon class
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
	Methods
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
}


/*--- Set the flag data ---*/
reliable server simulated function SetFlagData(byte Index, A_FlagBase FlagParent)
{
	TeamIndex = Index;
	HomeBase = FlagParent;
	LightColor = (TeamIndex == 0) ? RedTeamColor : BlueTeamColor;
	`log("AF > SetFlagData" @self);
}
reliable client simulated function ClientSetFlagData()
{
	FlagLight.SetLightProperties(
		FlagLight.Brightness,
		LightColor
	);
	`log("AF > ClientSetFlagData" @self);
}


/*--- Set holder ---*/
simulated function SetHolder(P_Pawn NewHolder)
{
	Holder = NewHolder;
}


/*--- Return the flag or retake it ---*/
event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local P_Pawn PP;
	`log("AF > Touch" @self);
	
	// Only valid touches are accepted
	if (P_Pawn(Other) == None)
		return;
	PP = P_Pawn(Other);
	if (PP.PlayerReplicationInfo == None)
	{
		`log("AF > No PR for pawn" @self);
		return;
	}
	if (!bIsReturnable)
	{
		`log("AF > Not returnable !" @self);
		return;
	}

	// Friendly touch : return
	if (TeamIndex == DVPlayerRepInfo(PP.PlayerReplicationInfo).Team.TeamIndex)
	{
		A_FlagBase(HomeBase).FlagReturned();
		`log("AF > Return" @self);
		Destroy();
	}
	
	// Or... Retake
	else
	{
		//TODO trigger sound
		AttachFlag(PP);
		`log("AF > Retake" @self);
	}
	bIsReturnable = false;
	bForceNetUpdate = true;
}


/*--- Get the flag ---*/
reliable server simulated function AttachFlag(P_Pawn PP)
{
	SetBase(PP);
	PP.EnemyFlag = self;
	SetHolder(PP);
	
	if (WorldInfo.NetMode == NM_DedicatedServer)
		G_CaptureTheFlag(WorldInfo.Game).FlagTaken(TeamIndex);
		
	bForceNetUpdate = true;
}


/*--- Drop the flag ---*/
simulated function Drop(Controller OldOwner)
{
	bIsReturnable = true;
	bCollideWorld = true;
	bForceNetUpdate = true;
	
	SetBase(None);
	SetCollisionSize(0.75 * DefaultRadius, DefaultHeight);
	SetCollisionType(COLLIDE_BlockAll);
	SetCollision(true, false);
	SetTimer(AutoReturnTime, false, 'ReturnOnTimeOut');
	
	SetPhysics(PHYS_Falling);
	Velocity = 100.0 * VRand();
	Velocity.Z += 300.0;
	
	`log("AF > Drop" @self);
}


/*-- Return when dropped for too long ---*/
simulated function ReturnOnTimeOut()
{
	A_FlagBase(HomeBase).FlagReturned();
	Destroy();
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
	bHome=true
	bStatic=false
 	bHardAttach=true
	bCollideActors=true
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
		Brightness=3.0
		LightColor=(R=10,G=255,B=0)
		Translation=(X=-40)
		Radius=350.0
		bEnabled=true
		CastShadows=true
		bRenderLightShafts=true
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
	Begin Object Class=SkeletalMeshComponent Name=TheFlagSkelMesh
		PhysicsWeight=0
		BlockActors=false
		CollideActors=false
		BlockRigidBody=true
		RBChannel=RBCC_Nothing
		bHasPhysicsAssetInstance=true
		RBCollideWithChannels=(Default=false,GameplayPhysics=false,EffectPhysics=false,Cloth=true)
		
		ClothRBChannel=RBCC_Cloth
		ClothWind=(X=20.0,Y=10.0)
		bEnableClothSimulation=true
		bAutoFreezeClothWhenNotRendered=true
		
		scale=0.5
		bPerBoneMotionBlur=true
		bAcceptsDynamicDecals=false
		bUpdateSkelWhenNotRendered=false
		Translation=(X=-40.0,Y=0.0,Z=-40.0)
		LightEnvironment=FlagLightEnvironment
		SkeletalMesh=SkeletalMesh'DV_Gameplay.Mesh.SK_Flag'
		PhysicsAsset=PhysicsAsset'DV_Gameplay.Mesh.SK_Flag_Physics'
		
	End Object
	SkelMesh=TheFlagSkelMesh;
	Components.Add(TheFlagSkelMesh)
	CollisionComponent=TheFlagSkelMesh
}
