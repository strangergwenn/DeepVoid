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

/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

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
	bHome=True
	bStatic=False
	bCollideActors=true

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=+0048.000000
		CollisionHeight=+0085.000000
		CollideActors=true
	End Object

	Begin Object class=PointLightComponent name=FlagLightComponent
		Brightness=5.0
		LightColor=(R=255,G=255,B=255)
		Radius=250.0
		CastShadows=false
		bEnabled=true
		LightingChannels=(Dynamic=FALSE,CompositeDynamic=FALSE)
	End Object
	Components.Add(FlagLightComponent)

	Begin Object Class=DynamicLightEnvironmentComponent Name=FlagLightEnvironment
	    bDynamic=FALSE
	End Object
	Components.Add(FlagLightEnvironment)

	Begin Object Class=SkeletalMeshComponent Name=TheFlagSkelMesh
		CollideActors=false
		BlockActors=false
		PhysicsWeight=0
		bHasPhysicsAssetInstance=true
		BlockRigidBody=true
		RBChannel=RBCC_Nothing
		RBCollideWithChannels=(Default=FALSE,GameplayPhysics=FALSE,EffectPhysics=FALSE,Cloth=TRUE)
		ClothRBChannel=RBCC_Cloth
		LightEnvironment=FlagLightEnvironment
		bEnableClothSimulation=true
		bAutoFreezeClothWhenNotRendered=true
		bUpdateSkelWhenNotRendered=false
		bAcceptsDynamicDecals=FALSE
		ClothWind=(X=20.0,Y=10.0)
		Translation=(X=0.0,Y=0.0,Z=-40.0)  // this is needed to make the flag line up with the flag base
		bPerBoneMotionBlur=true
	End Object
	SkelMesh=TheFlagSkelMesh;
	Components.Add(TheFlagSkelMesh)

 	bHardAttach=true
}
