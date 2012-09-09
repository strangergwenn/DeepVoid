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

var (Target) float				MaxLife;
var (Target) float				MinLife;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var SkeletalMeshComponent		Mesh;

var float						TimeAlive;

var bool						bAlive;
var bool						bUp;


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Target registration ---*/
simulated function PostBeginPlay()
{
	`log("AT > PostBeginPlay" @self);
	super.PostBeginPlay();
	
	// Registering to master...
	if (Manager != None)
	{
		Manager.RegisterTarget(self);
	}
	
	// Initial shutdown
	bAlive = true;
	bUp = true;
	DeActivateTarget();
}


/*--- Target going up ---*/
simulated function ActivateTarget()
{
	`log("AT > ActivateTarget" @self);
	if (!bAlive)
	{
		bAlive = true;
		bUp = true;
		
		if (SoundOnRaise != None)
			PlaySound(SoundOnRaise);
		Mesh.PlayAnim('Raise');
		
		SetTimer(MinLife + FRand() * MaxLife, false, 'DeActivateTarget');
	}
}


/*--- Target going down ---*/
simulated function DeActivateTarget()
{
	`log("AT > DeActivateTarget" @self);
	if (bUp)
	{
		ClearTimer('DeActivateTarget');
		Manager.TargetDown(self, TimeAlive, !bAlive);
		
		TimeAlive = 0.0;
		bAlive = false;
		bUp = false;
			
		if (bAlive && SoundOnKill != None)
		{
			PlaySound(SoundOnKill);
		}
		Mesh.PlayAnim('Raise',,false,true,,true);
	}
}


/*--- Damage : kill target ---*/
simulated function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum,
			class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if (bAlive)
	{
		`log("AT > TakeDamage" @self);
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
	MinLife=0.5
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
		SkeletalMesh=SkeletalMesh'DV_Spacegear.Mesh.SK_target'
		PhysicsAsset=PhysicsAsset'DV_Spacegear.Mesh.SK_target_Physics'
		AnimSets.Add(AnimSet'DV_Spacegear.Mesh.K_target')
	End Object
	Mesh=MySkeletalMeshComponent
 	Components.Add(MySkeletalMeshComponent)
	CollisionComponent=MySkeletalMeshComponent

	// Physics
	bEdShouldSnap=true
	bCollideActors=true
	bCollideWorld=true
	bBlockActors=true
	bPathColliding=true
}
