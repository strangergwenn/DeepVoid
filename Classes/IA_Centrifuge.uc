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

var (Centrifuge) const float		PawnCheckRadius;

var (Centrifuge) const vector		TravellingOrigin;

var (Centrifuge) const SoundCue		CrushSound;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var AmbientSoundMovable				TravelSound;

var repnotify float					NewYawAngle;


/*----------------------------------------------------------
	Replication
----------------------------------------------------------*/

replication
{
	if (bNetDirty)
		NewYawAngle;
}

simulated event ReplicatedEvent(name VarName)
{
	local rotator NewRot;
	if (VarName == 'NewYawAngle')
	{
		NewRot.Yaw = NewYawAngle;
		SetRotation(NewRot);
		return;
	}
}


/*----------------------------------------------------------
	Events
----------------------------------------------------------*/

/*--- Initial setup ---*/
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (WorldInfo.NetMode == NM_Standalone || WorldInfo.NetMode == NM_DedicatedServer)
	{
		SetTimer(1.0, true, 'ServerUpdateRot');
	}
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		TravelSound = Spawn(class'IA_CentrifugeSound', self);
	}
}


/*--- Server rotation update to clients ---*/
reliable server simulated function ServerUpdateRot()
{
	NewYawAngle = Rotation.Yaw;
	bForceNetUpdate = true;
}


/*--- Target designation --*/
simulated function Tick(float DeltaTime)
{
	local DVPawn P;
	Super.Tick(DeltaTime);

	foreach WorldInfo.AllPawns(class'DVPawn', P, (TravellingOrigin >> Rotation), PawnCheckRadius)
	{
		if (P.Health > 0)
		{
			P.KilledBy(P);
			if (CrushSound != None)
			{
				PlaySound(CrushSound, false, true, false, P.Location);
			}
		}
	}

	ClientTick();
}


/*--- Clientside tick ---*/
reliable client simulated function ClientTick()
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		TravelSound.SetLocation(TravellingOrigin >> Rotation);
	}
}


/*--- Bumped ---*/
event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
	`log("Bump" @self @Other);
	if (Other.IsA('DVPawn'))
	{
		Other.KilledBy(DVPawn(Other));
		if (CrushSound != None)
		{
			PlaySound(CrushSound, false, true, false, Other.Location);
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
		CastShadow=false
		bAcceptsLights=true
		bCastStaticShadow=false
		bCastDynamicShadow=false
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		BlockNonzeroExtent=true
		BlockZeroExtent=true
		BlockRigidBody=true
		CollideActors=true
		BlockActors=true
		StaticMesh=StaticMesh'Peripheral.Mesh.SM_Centrifuge'
	End Object

	// Travelling
	PawnCheckRadius=400.0
	TravellingOrigin=(X=-6500,Z=600)

	// Physics
	RotationRate=(Yaw=1700)
	Physics=PHYS_ROTATING
	RemoteRole=ROLE_SimulatedProxy
	CollisionType=COLLIDE_BlockAll
	bAlwaysEncroachCheck=true
	bReplicateMovement=true
	bAlwaysRelevant=true
	bCollideActors=true
	bCollideWorld=true
	bBlockActors=true
}
