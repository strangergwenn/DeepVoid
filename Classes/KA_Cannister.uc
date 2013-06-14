/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class KA_Cannister extends KActor
	ClassGroup(DeepVoid)
	placeable;


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (Cannister) const int					MaxBurns;

var (Cannister) const float					BurnTime;
var (Cannister) const float					BurnStrength;

var (Cannister) const vector				BurnOrigin;

var (Cannister) const SoundCue				BurnSound;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var bool									bPhysBurning;

var int 									Burns;

var ParticleSystemComponent					Fire;


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Damage management for blood FX ---*/
simulated event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	if (!bPhysBurning && Burns < MaxBurns)
	{
		if (BurnSound != None)
		{
			PlaySound(BurnSound, false, true, false, Location);
		}
		SetTimer(BurnTime, false, 'BurnOut');
		Fire.ActivateSystem();
		bPhysBurning = true;
		Burns ++;
	}
}


/*--- Burning complete --*/
simulated function BurnOut()
{
	bPhysBurning = false;
}


/*--- Target designation --*/
simulated function Tick(float DeltaTime)
{
	local vector Direction;
	Super.Tick(DeltaTime);

	if (bPhysBurning)
	{
		Direction = 0.01 * vect(0,0,1) - Normal(BurnOrigin >> Rotation);
		ApplyImpulse(Direction, BurnStrength, Location + (BurnOrigin >> Rotation));
	}
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultProperties
{
	// Mesh
	Begin Object Class=ParticleSystemComponent Name=FireFX
		Template=ParticleSystem'DV_CoreEffects_FX.FX.PS_GasFire'
		Translation=(Z=75)
		bAutoActivate=false
	End Object
	Components.Add(FireFX)
	Fire=FireFX

	// Behaviour
	bWakeOnLevelStart=false
	bEnableStayUprightSpring=false
	BurnOrigin=(Z=75)
	BurnStrength=40.0
	BurnTime=3.0
	MaxBurns=1
}
