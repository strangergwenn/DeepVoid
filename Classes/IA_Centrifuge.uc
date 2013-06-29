/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class IA_Centrifuge extends InterpActor
	placeable
	ClassGroup(DeepVoid);


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (Centrifuge) const SoundCue		CrushSound;
var (Centrifuge) const vector		TravelSoundOrigin;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var AmbientSoundMovable				TravelSound;


/*----------------------------------------------------------
	Events
----------------------------------------------------------*/

/*--- Initial setup ---*/
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	TravelSound = Spawn(class'IA_CentrifugeSound', self);
}


/*--- Target designation --*/
simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	TravelSound.SetLocation(TravelSoundOrigin >> Rotation);
}


/*--- Bumped ---*/
event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
	if (Other.IsA('DVPawn'))
	{
		Other.KilledBy(DVPawn(Other));
		if (CrushSound != None)
		{
			PlaySound(CrushSound, false, true, false, Location);
		}
	}
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultProperties
{
	// Mesh
	Begin Object Name=StaticMeshComponent0
		BlockActors=true
		CollideActors=true
		BlockRigidBody=true
		BlockZeroExtent=true
		BlockNonzeroExtent=true
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bAcceptsLights=true
		CastShadow=false
		bCastStaticShadow=false
		bCastDynamicShadow=false
		StaticMesh=StaticMesh'Peripheral.Mesh.SM_Centrifuge'
	End Object

	// Sound
	TravelSoundOrigin=(X=-6500,Z=400)

	// Physics
	CollisionType=COLLIDE_BlockAll
	Physics=PHYS_Rotating
	RotationRate=(Yaw=1400)
	bCollideActors=true
	bCollideWorld=true
	bBlockActors=true
}
