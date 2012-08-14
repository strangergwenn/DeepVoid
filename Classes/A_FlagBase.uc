/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class A_FlagBase extends Actor
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

var float 						CurrentPeriod;


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Detection tick ---*/
simulated function Tick(float DeltaTime)
{
	local DVPawn P;
	CurrentPeriod -= DeltaTime;
	
	if (CurrentPeriod <= 0)
	{
		CurrentPeriod = DetectionPeriod;
		foreach AllActors(class'DVPawn', P)
		{
			if (VSize(P.Location - Location) < DetectionDistance && P != OldPawn)
			{
				OldPawn = P;
				
				if (WorldInfo.NetMode == NM_DedicatedServer)
					G_CaptureTheFlag(WorldInfo.Game).FlagTaken(TeamIndex);
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
		Scale=0.7
		BlockActors=true
		BlockZeroExtent=true
		BlockRigidBody=true
		BlockNonzeroExtent=true
		CollideActors=true
		LightEnvironment=MyLightEnvironment
		StaticMesh=StaticMesh'DV_Spacegear.Mesh.SM_FlagBase'
	End Object
	CollisionComponent=GroundBase
	Components.Add(GroundBase)
	Mesh=GroundBase
	
 	// Gameplay
	DetectionPeriod=0.25
	DetectionDistance=200.0
	
 	// Mesh settings
	bEdShouldSnap=true
	bCollideActors=true
	bCollideWorld=true
	bBlockActors=true
	bPathColliding=true
}
