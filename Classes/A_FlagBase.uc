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


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var StaticMeshComponent			Mesh;

var DVPlayerController			PC;
var DVPawn						OldPawn;

var A_Flag						OwnedFlag;

var float 						CurrentPeriod;

var bool						bHasFlag;

replication
{
	if ( (Role==ROLE_Authority) && bNetDirty )
		TeamIndex, Mesh, bHasFlag, OwnedFlag;
}


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Game startup ---*/
simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SpawnFlag();
}


/*--- (Re)spawn the flag ---*/
simulated function SpawnFlag()
{
	if (Role >= ROLE_Authority && G_CaptureTheFlag(WorldInfo.Game) != None)
	{
		OwnedFlag = Spawn(class'A_Flag', self);
		OwnedFlag.SetFlagData(TeamIndex, self);
		bHasFlag = true;
	}
}


/*--- The flag was returned ---*/
simulated function FlagReturned()
{
	if (WorldInfo.NetMode == NM_DedicatedServer)
		G_CaptureTheFlag(WorldInfo.Game).FlagReturned(TeamIndex);
	SpawnFlag();
}


/*--- Detection tick ---*/
simulated function Tick(float DeltaTime)
{
	local P_Pawn P;
	CurrentPeriod -= DeltaTime;
	
	if (CurrentPeriod <= 0 && bHasFlag)
	{
		CurrentPeriod = DetectionPeriod;
		
		foreach AllActors(class'P_Pawn', P)
		{
			if (VSize(P.Location - Location) < DetectionDistance && P != OldPawn)
			{
				// Flag take
				if (TeamIndex != DVPlayerRepInfo(P.PlayerReplicationInfo).Team.TeamIndex)
				{
					OldPawn = P;
					if (WorldInfo.NetMode == NM_DedicatedServer)
					{
						G_CaptureTheFlag(WorldInfo.Game).FlagTaken(TeamIndex);
					}
					`log("AFB > Flag take" @OwnedFlag);
					P.Mesh.AttachComponentToSocket(OwnedFlag.SkelMesh, 'WeaponPoint');
					P.EnemyFlag = OwnedFlag;
					bHasFlag = false;
				}
				
				// Flag capture
				else if (P.EnemyFlag != None)
				{
					if (WorldInfo.NetMode == NM_DedicatedServer)
					{
						G_CaptureTheFlag(WorldInfo.Game).FlagCaptured(P.EnemyFlag.TeamIndex);
					}
					`log("AFB > Flag capture" @P.EnemyFlag);
					A_FlagBase(P.EnemyFlag.HomeBase).SpawnFlag();
					P.Mesh.DetachComponent(P.EnemyFlag.SkelMesh);
					P.EnemyFlag.Destroy();
					P.EnemyFlag = None;
					SpawnFlag();
				}
			}
		}
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
		
		Scale=0.7
		Translation=(Z=-48)
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		StaticMesh=StaticMesh'DV_Spacegear.Mesh.SM_FlagBase'
		
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
