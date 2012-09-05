/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class A_TargetManager extends Actor
	HideCategories(Display,Collision,Physics)
	ClassGroup(DeepVoid)
	placeable;


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (Target) const float		MaxTargetInterval;

var (Target) const int			MaxTargetToShoot;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var SkeletalMeshComponent		Mesh;

var array<A_Target>				TargetList;

var float						OverallTime;

var int							TargetsShot;


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Initial setup ---*/
function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(FRand() * MaxTargetInterval, false, 'RaiseTarget');
}


/*--- New target is ready to use ---*/
simulated function RegisterTarget(A_Target trg)
{
	TargetList.AddItem(trg);
	`log("ATM > RegisterTarget" @trg @self);
}


/*--- Raise a random (non-raised) target ---*/
simulated function RaiseTarget()
{
	local A_Target trg;
	`log("ATM > RaiseTarget" @self);
	
	// Activate the target
	do
	{
		trg = TargetList[Rand(TargetList.Length)];
	}
	until (trg.bAlive);
	trg.ActivateTarget();
	// TODO SOUND
	
	// Moar !
	if (TargetsShot < MaxTargetToShoot)
	{
		AllTargetsShots();
		ClearTimer('RaiseTarget');
	}
	else
	{
		SetTimer(FRand() * MaxTargetInterval, false, 'RaiseTarget');
	}
}


/*--- Target shot or auto-deactivated ---*/
simulated function TargetDown(A_Target trg, float TimeAlive, bool bWasShot)
{
	`log("ATM > TargetKilled" @trg @TimeAlive @self);
	
	if (bWasShot)
	{
		TargetsShot += 1;
		// TODO SCORE UPDATE
	}
	
	OverallTime += TimeAlive;
}


/*--- End of game ---*/
simulated function AllTargetsShots()
{
	`log("ATM > AllTargetsShots in" @OverallTime @self);
	
	// TODO END SCORE
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Gameplay
	MaxTargetInterval=1.0
	MaxTargetToShoot=30
	
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
