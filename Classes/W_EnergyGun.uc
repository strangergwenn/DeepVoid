/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class W_EnergyGun extends W_Rifle;


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (DVEG) const SoundCue			SpinupSound;
var (DVEG) const SoundCue			ReadySound;

var (DVEG) const float 				SpinupTime;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var bool							bReadyToFire;
var bool							bSpinningUp;

var repnotify vector				ImpactPosition;

replication
{
	if (bNetDirty)
		bReadyToFire, bSpinningUp, ImpactPosition;
}

simulated event ReplicatedEvent(name VarName)
{	
	`log("DVEG > ReplicatedEvent" @VarName);
	if (VarName == 'ImpactPosition')
	{
		PlayFiringEffects(ImpactPosition);
	}
}


/*----------------------------------------------------------
	Firing management
----------------------------------------------------------*/

/*--- Target designation --*/
simulated function Tick(float DeltaTime)
{
	// Init
	local vector Impact, SL, Unused;
	local rotator SR;
	FrameCount += 1;
	
	if (FrameCount % TickDivisor == 0 && Owner != None)
	{
		// Trace
		SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation('Mount1', SL, SR);
		if (DVPawn(Owner) != None)
		{
			if (DVPlayerController(DVPawn(Owner).Controller) != None)
			{
				DVPlayerController(DVPawn(Owner).Controller).TargetObject = Trace(
					Impact,
					Unused,
					SL + vector(SR) * 10000.0,
					SL,
					true,,, TRACEFLAG_Bullet
				);
				if (DVPlayerController(DVPawn(Owner).Controller).TargetObject != None && bReadyToFire)
				{
					ImpactPosition = Impact;
					bForceNetUpdate = true;
				}
			}
		}
	}
}


/*--- Launch spinup ---*/
simulated function BeginFire(byte FireModeNum)
{
	`log("DVEG > BeginFire" @self);
	if (FireModeNum == 1 || bReadyToFire)
	{
		super.BeginFire(FireModeNum);
	}
	
	if (FireModeNum == 0 && !bSpinningUp && AmmoCount > 0)
	{
		SetTimer(SpinupTime, false, 'SpinnedUp');
		bSpinningUp = true;
	
		if (SpinupSound != None)
		{
			PlaySound(SpinupSound, false, true, false, Owner.Location);
		}
	}
}


/*--- Weapon ready ---*/
simulated function SpinnedUp()
{
	if (ReadySound != None)
	{
		PlaySound(ReadySound, false, true, false, Owner.Location);
	}
	
	bReadyToFire = true;
	BeginFire(0);
}


/*--- Fire ended ---*/
simulated function StopFire(byte FireModeNum)
{
	`log("DVEG > StopFire" @self);
	bSpinningUp = false;
	bReadyToFire = false;
	ClearTimer('SpinnedUp');
	super.StopFire(FireModeNum);
}


/*--- Fire ended ---*/
reliable server simulated function ServerStopFire(byte FireModeNum)
{
	`log("DVEG > ServerStopFire" @self);
	bSpinningUp = false;
	bReadyToFire = false;
	ClearTimer('SpinnedUp');
	EndFire(FireModeNum);
}


/*----------------------------------------------------------
	Firing effect
----------------------------------------------------------*/

/*--- Muzzle flash ---*/
simulated function PlayFiringEffects(vector HitLocation)
{
	`log("DVEG > PlayFiringEffects" @self);
	if (!bSilenced && MuzzleFlashPSC != None && !bWeaponEmpty)
	{
		MuzzleFlashPSC.SetVectorParameter('ShockBeamEnd', HitLocation);
		MuzzleFlashPSC.ActivateSystem();
		ImpactPosition = HitLocation;
	}
}

/*--- Muzzle flash ---*/
simulated function PlayImpactEffects(vector HitLocation)
{
	`log("DVEG > PlayImpactEffects" @self);
	ImpactPosition = HitLocation;
	bForceNetUpdate = true;
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/
defaultproperties
{
	// Mesh
	Begin Object Name=WeaponMesh
		SkeletalMesh=SkeletalMesh'DV_Weapons.Mesh.SK_Plasma'
		Translation=(X=3.0, Y=-2.5, Z=0.5)
		Scale=0.95
	End Object
	Mesh=WeaponMesh
	
	// Settings
	WeaponIconPath="DV_Weapons"
	WeaponIcon=Texture2D'DV_Weapons.Icon.T_W_EnergyGun'
	WeaponFireSnd[0]=SoundCue'DV_Sound.Weapons.A_PlasmaShot'
	
	// Plasma
	MuzzleFlashPSCTemplate=ParticleSystem'DV_CoreEffects.FX.PS_PlasmaBeam'
	SpinupSound=SoundCue'DV_Sound.Weapons.A_PlasmaSpinup'
	ReadySound=SoundCue'DV_Sound.Weapons.A_Empty'
	
	// Weaponry
	InstantHitMomentum(0)=40000.0
	InstantHitDamage(0)=40.0
	FireInterval(0)=0.33
	SmoothingFactor=1.0
	TickDivisor=2
	SpinupTime=1.0
	Spread(0)=0.0
	MaxAmmo=50
	bLongRail=true
	bCannonMount=false
}
