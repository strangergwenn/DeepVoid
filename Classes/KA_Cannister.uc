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

var (Cannister) const vector				BurnDir;

var (Cannister) const SoundCue				BurnSound;
var (Cannister) const SoundCue				BumpSound;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var repnotify bool							bPhysBurning;

var int 									Burns;

var ParticleSystemComponent					Fire;


/*----------------------------------------------------------
	Replication
----------------------------------------------------------*/

replication
{
	if ( bNetDirty )
		bPhysBurning, Burns;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'bPhysBurning')
	{
		ClientBurnStart();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Bumped ---*/
event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
	if (BumpSound != None)
	{
		PlaySound(BumpSound, false, true, false, Location);
	}
}


/*--- Damage management for fire FX ---*/
simulated event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	ServerBurnStart();
}


/*--- Damage management for fire FX ---*/
simulated function TakeRadiusDamage (
	Controller			InstigatedBy,
	float				BaseDamage,
	float				DamageRadius,
	class<DamageType>	DamageType,
	float				Momentum,
	vector				HurtOrigin,
	bool				bFullDamage,
	Actor               DamageCauser,
	optional float      DamageFalloffExponent=1.f
)
{
	Super.TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum,
			HurtOrigin, bFullDamage, DamageCauser);
	ServerBurnStart();
}


/*--- Burning start (server) --*/
reliable server simulated function ServerBurnStart()
{
	if (!bPhysBurning && Burns < MaxBurns)
	{
		bPhysBurning = true;
		Burns ++;
	}
	if (WorldInfo.NetMode == NM_StandAlone)
	{
		ClientBurnStart();
	}
}


/*--- Burning start --*/
reliable client simulated function ClientBurnStart()
{
	if (BurnSound != None)
	{
		PlaySound(BurnSound, false, true, false, Location);
	}
	SetTimer(BurnTime, false, 'BurnOut');
	Fire.ActivateSystem();
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
		Direction = 0.01 * vect(0,0,1) - Normal(BurnDir >> Rotation);
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
		Rotation=(Pitch=16384)
		bAutoActivate=false
	End Object
	Components.Add(FireFX)
	Fire=FireFX

	// Behaviour
	bWakeOnLevelStart=false
	bEnableStayUprightSpring=false
	BurnOrigin=(Z=75)
	BurnDir=(X=1)
	BurnStrength=40.0
	BurnTime=3.0
	MaxBurns=1
}
