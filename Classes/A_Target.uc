/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class A_Target extends Actor
	HideCategories(Display,Collision,Physics)
	ClassGroup(DeepVoid)
	placeable;


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (Target) A_TargetManager	Manager;

var (Target) const SoundCue		SoundOnRaise;
var (Target) const SoundCue		SoundOnKill;

var (Target) const float		MaxLife;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var SkeletalMeshComponent		Mesh;

var float						TimeAlive;

var bool						bAlive;


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Target registration ---*/
simulated function PostBeginPlay()
{
	`log("AT > PostBeginPlay" @self);
	super.PostBeginPlay();
	if (Manager != None)
	{
		Manager.RegisterTarget(self);
	}
}


/*--- Target going up ---*/
simulated function ActivateTarget()
{
	`log("AT > ActivateTarget" @self);
	if (!bAlive)
	{
		bAlive = true;
		
		if (SoundOnRaise != None)
			PlaySound(SoundOnRaise);
		Mesh.PlayAnim('Raise');
		
		SetTimer(FRand() * MaxLife, false, 'DeActivateTarget');
	}
}


/*--- Target going down ---*/
simulated function DeActivateTarget()
{
	`log("AT > DeActivateTarget" @self);
	if (bAlive)
	{
		Manager.TargetDown(self, TimeAlive, !bAlive);
		TimeAlive = 0.0;
		bAlive = false;
		
		if (SoundOnKill != None)
			PlaySound(SoundOnKill);
		Mesh.PlayAnim('Lower');
	}
}


/*--- Damage : kill target ---*/
simulated function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum,
			class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	`log("AT > TakeDamage" @self);
	if (bAlive)
	{
		bAlive = false;
		DeActivateTarget();
	}
}


/*--- Detection tick ---*/
simulated function Tick(float DeltaTime)
{
	if (bAlive)
	{
		TimeAlive += DeltaTime;
	}
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Gameplay
	MaxLife=3.0
	SoundOnRaise=SoundCue'DV_Sound.UI.A_Bip'
	SoundOnKill=SoundCue'DV_Sound.UI.A_Bip'
	
	// Light
	Begin Object class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
		bDynamic=true
	End Object
	Components.Add(MyLightEnvironment)

	// Animation
	Begin Object class=AnimNodeSequence Name=MyMeshSequence
	End Object

	// Mesh
	Begin Object class=SkeletalMeshComponent Name=MySkeletalMeshComponent
		LightEnvironment=MyLightEnvironment
		Animations=MyMeshSequence
		BlockActors=true
		BlockZeroExtent=true
		BlockRigidBody=true
		BlockNonzeroExtent=true
		CollideActors=true

		// Content
		//SkeletalMesh=SkeletalMesh'Chest.Mesh.SK_Chest'
		//PhysicsAsset=PhysicsAsset'Chest.Mesh.SK_Chest_Physics'
		//AnimSets.Add(AnimSet'Chest.Anim.K_Chest')
	End Object
	Mesh=MySkeletalMeshComponent
 	Components.Add(MySkeletalMeshComponent)
	CollisionComponent=MySkeletalMeshComponent

	// Physics
	Physics=PHYS_RigidBody
	bEdShouldSnap=true
	bCollideActors=true
	bCollideWorld=true
	bBlockActors=true
	bPathColliding=true
}
