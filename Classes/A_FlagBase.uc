/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class A_FlagBase extends UDKGameObjective
	placeable
	ClassGroup(DeepVoid)
	hidecategories(Collision, Physics);


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (Flag) const float 			DetectionDistance;
var (Flag) const float 			DetectionPeriod;

var (Flag) const byte 			TeamIndex;

var (Flag) bool					bHasFlag;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var StaticMeshComponent			Mesh;

var A_Flag						OwnedFlag;

var float 						CurrentPeriod;

replication
{
	if (bNetDirty)
		TeamIndex, Mesh, bHasFlag, OwnedFlag;
}


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Game startup ---*/
simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	// CTF specific
	if (G_CaptureTheFlag(WorldInfo.Game) != None)
	{
		`log("AF > PostBeginPlay" @self);
		SpawnFlag();
	}
}


/*--- (Re)spawn the flag ---*/
simulated function SpawnFlag()
{
	if (Role >= ROLE_Authority && G_CaptureTheFlag(WorldInfo.Game) != None)
	{
		OwnedFlag = Spawn(class'A_Flag', self);
		OwnedFlag.SetFlagData(TeamIndex, self);
		`log("AFB > Flag spawned" @OwnedFlag @self);
		bHasFlag = true;
	}
}


/*--- The flag was returned ---*/
simulated function FlagReturned()
{
	`log("AFB > Flag returned" @self);
	if (WorldInfo.NetMode == NM_DedicatedServer)
		G_CaptureTheFlag(WorldInfo.Game).FlagReturned(TeamIndex);
	SpawnFlag();
}


/*--- Detection tick ---*/
simulated function Tick(float DeltaTime)
{
	local P_Pawn P;
	CurrentPeriod -= DeltaTime;
	
	// CTF specific
	if (G_CaptureTheFlag(WorldInfo.Game) == None)
	{
		return;
	}

	if (CurrentPeriod <= 0 && bHasFlag)
	{
		CurrentPeriod = DetectionPeriod;
		
		foreach AllActors(class'P_Pawn', P)
		{
			// Detection condition
			if (VSize(P.Location - Location) < DetectionDistance)
			{
				// Flag take
				if (TeamIndex != DVPlayerRepInfo(P.PlayerReplicationInfo).Team.TeamIndex)
				{
					`log("AFB > Flag take" @OwnedFlag @self);
					OwnedFlag.AttachFlag(P);
					bHasFlag = false;
				}
				
				// Flag capture
				else if (P.EnemyFlag != None)
				{
					if (WorldInfo.NetMode == NM_DedicatedServer)
					{
						G_CaptureTheFlag(WorldInfo.Game).FlagCaptured(P.EnemyFlag.TeamIndex);
					}
					`log("AFB > Flag capture" @P.EnemyFlag @self);
					A_FlagBase(P.EnemyFlag.HomeBase).SpawnFlag();
					P.EnemyFlag.SetBase(None);
					P.EnemyFlag.SkelMesh.DetachFromAny();
					P.EnemyFlag.Destroy();
					P.EnemyFlag = None;
				}

				// Nothing
				else
				{
					`log("AFB > Neutral pawn" @P @self);
				}
			}
		}
	}

	else if (OwnedFlag == None)
	{
		`log("AFB > Flag respawn on error" @self);
		SpawnFlag();
	}
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultProperties
{
	// Lighting
	Begin Object class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
		bDynamic=true
	End Object
	Components.Add(MyLightEnvironment)
	
	// Mesh
	Begin Object class=StaticMeshComponent name=GroundBase		
		BlockActors=true
		CollideActors=true
		BlockRigidBody=true
		BlockZeroExtent=true
		BlockNonzeroExtent=true
		
		CastShadow=false
		bAcceptsLights=true
		bCastDynamicShadow=false
		bForceDirectLightMap=true
		LightEnvironment=MyLightEnvironment
		
		Scale=0.4
		Translation=(X=-40.0,Y=0.0,Z=-48.0)
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		StaticMesh=StaticMesh'DV_Gameplay.Mesh.SM_Base'
		
	End Object
	CollisionComponent=GroundBase
	Components.Add(GroundBase)
	Mesh=GroundBase
	
 	// Gameplay
	DetectionPeriod=0.25
	DetectionDistance=200.0
	
	// Networking
	bStatic=false
	bHidden=false
	bAlwaysRelevant=true
	bTickIsDisabled=false
	NetUpdateFrequency=1
	RemoteRole=ROLE_SimulatedProxy
	
 	// Mesh settings
	bEdShouldSnap=true
	bCollideActors=true
	bCollideWorld=true
	bBlockActors=true
	bPathColliding=true
}
