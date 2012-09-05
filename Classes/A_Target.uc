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
		
		// TODO ANIM
		
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
		
		// TODO ANIM
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
	
	// Light
	Begin Object class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
		bDynamic=true
	End Object
	Components.Add(MyLightEnvironment)

	// Mesh
	Begin Object class=SkeletalMeshComponent Name=MySkeletalMeshComponent
		LightEnvironment=MyLightEnvironment
	End Object
	Mesh=MySkeletalMeshComponent
 	Components.Add(MySkeletalMeshComponent)
	CollisionComponent=MySkeletalMeshComponent

	// Physics
	bEdShouldSnap=true
	bCollideActors=true
	bBlockActors=true
}
