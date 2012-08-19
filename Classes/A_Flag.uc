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


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var PointLightComponent 				FlagLight;

var byte 								TeamIndex;

var bool								bIsReturnable;

replication
{
	if ( (Role==ROLE_Authority) && bNetDirty )
		TeamIndex, bIsReturnable, FlagLight;
}


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Set the flag data ---*/
simulated function SetFlagData(byte Index, A_FlagBase FlagParent)
{
	TeamIndex = Index;
	HomeBase = FlagParent;
	
	FlagLight.SetLightProperties(
		FlagLight.Brightness,
		(TeamIndex == 0) ? RedTeamColor : BlueTeamColor
	);
}


/*--- Return the flag or retake it ---*/
event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	// Only player touches
	if (DVPawn(Other) == None)
	{
		return;
	}

	// Friendly touch : return
	if (TeamIndex == DVPlayerRepInfo(DVPawn(Other).PlayerReplicationInfo).Team.TeamIndex)
	{
		A_FlagBase(HomeBase).FlagReturned();
		`log("AF > Return" @self);
		Destroy();
	}
	
	// Or... Retake
	else
	{
		//TODO trigger sound
		DVPawn(Other).Mesh.AttachComponentToSocket(SkelMesh, 'WeaponPoint');
		`log("AF > Retake" @self);
	}
	bIsReturnable = false;
}


/*--- Drop the flag ---*/
reliable server simulated function Drop(Controller OldOwner)
{
	bIsReturnable = true;
	bCollideWorld = true;
	SetCollision(true, false);
	SetPhysics(PHYS_Falling);
	`log("AF > Drop" @self);
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultProperties
{
	// Networking
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
	RedTeamColor=(R=200,G=20,B=20)
	BlueTeamColor=(R=20,G=20,B=200)

	// Collisions
	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=+0048.000000
		CollisionHeight=+0085.000000
		CollideActors=true
	End Object

	// Ambient light
	Begin Object class=PointLightComponent name=FlagLightComponent
		Brightness=5.0
		LightColor=(R=255,G=64,B=0)
		Radius=250.0
		CastShadows=false
		bEnabled=true
		LightingChannels=(Dynamic=false,CompositeDynamic=false)
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
		
		bPerBoneMotionBlur=true
		bAcceptsDynamicDecals=false
		bUpdateSkelWhenNotRendered=false
		Translation=(X=0.0,Y=0.0,Z=-40.0)
		LightEnvironment=FlagLightEnvironment
		SkeletalMesh=SkeletalMesh'CTF_Flag_IronGuard.Mesh.S_CTF_Flag_IronGuard'
		PhysicsAsset=PhysicsAsset'CTF_Flag_IronGuard.Mesh.S_CTF_Flag_IronGuard_Physics'
		
	End Object
	SkelMesh=TheFlagSkelMesh;
	Components.Add(TheFlagSkelMesh)
}
