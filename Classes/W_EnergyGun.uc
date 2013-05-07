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
	if (VarName == 'ImpactPosition' && bReadyToFire)
	{
		PlayFiringEffectsActual(ImpactPosition);
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}


/*----------------------------------------------------------
	Firing management
----------------------------------------------------------*/

/*--- Target designation --*/
simulated function Tick(float DeltaTime)
{
	// Init
	local vector Impact, SL, Unused, Destination;
	local rotator SR;
	FrameCount += 1;
	
	if (Owner != None)
	{
		// Trace
		SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation('Mount1', SL, SR);
		if (DVPawn(Owner) != None && Role >= ROLE_Authority)
		{
			if (DVPlayerController(DVPawn(Owner).Controller) != None && bReadyToFire)
			{
				Destination = SL + vector(SR) * 10000.0;
				DVPlayerController(DVPawn(Owner).Controller).TargetObject = Trace(
					Impact,
					Unused,
					Destination,
					SL,
					true,,, TRACEFLAG_Bullet
				);

				if (DVPlayerController(DVPawn(Owner).Controller).TargetObject != None)
				{
					ImpactPosition = Impact;
				}
				else
				{
					ImpactPosition = Destination;
				}

				bForceNetUpdate = true;
				if (WorldInfo.NetMode == NM_Standalone)
				{
					PlayFiringEffectsActual(ImpactPosition);
				}
			}
		}
	}
}


/*--- Launch spinup ---*/
simulated function BeginFire(byte FireModeNum)
{
	ImpactPosition = Vect(0,0,0);
	bForceNetUpdate = true;
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

	ImpactPosition = Vect(0,0,0);
	bForceNetUpdate = true;
	bReadyToFire = true;
	BeginFire(0);
}


/*--- Fire ended ---*/
simulated function StopFire(byte FireModeNum)
{
	bSpinningUp = false;
	bReadyToFire = false;
	bForceNetUpdate = true;
	ClearTimer('SpinnedUp');
	super.StopFire(FireModeNum);
}


/*--- Fire ended ---*/
reliable server simulated function ServerStopFire(byte FireModeNum)
{
	bSpinningUp = false;
	bReadyToFire = false;
	ClearTimer('SpinnedUp');
	EndFire(FireModeNum);
}


/*----------------------------------------------------------
	Firing effects
----------------------------------------------------------*/

/*--- Plasma beam ---*/
simulated function PlayFiringEffectsActual(vector HitLocation)
{
	// Init
	local DVPlayerController PC;
	PC = DVPlayerController(DVPawn(Owner).Controller);

	// Owner override
	if (PC != None)
	{
		if (PC.CurrentAimWorld != Vect(0,0,0))
		{
			HitLocation = PC.CurrentAimWorld;
		}
	}
	`log("DVEG > PlayFiringEffects" @HitLocation @self);

	// FX sequence
	if (!bWeaponEmpty)
	{
		if (MuzzleFlashPSC != None)
		{
			MuzzleFlashPSC.SetVectorParameter('ShockBeamEnd', HitLocation);
			MuzzleFlashPSC.ActivateSystem();
			ImpactPosition = HitLocation;
		}
		CauseMuzzleFlash();
		super.PlayImpactEffects(HitLocation);
	}
}

/*--- Disabled ---*/
simulated function PlayFiringEffects(vector HitLocation)
{}

/*--- Disabled ---*/
simulated function PlayImpactEffects(vector HitLocation)
{}


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
	ImpactEffect=(MaterialType=Water, ParticleTemplate=ParticleSystem'DV_CoreEffects.FX.PS_ImpactPlasma')
	MuzzleFlashPSCTemplate=ParticleSystem'DV_CoreEffects.FX.PS_PlasmaBeam'
	SpinupSound=SoundCue'DV_Sound.Weapons.A_PlasmaSpinup'
	ReadySound=SoundCue'DV_Sound.Weapons.A_Empty'

	// Recoil
	MaxSpread=0.0
	RecoilAngle=200
	
	// Weaponry
	MuzzleFlashLightClass=class'DeepVoid.EL_Plasma'
	InstantHitMomentum(0)=40000.0
	InstantHitDamage(0)=40.0
	FireInterval(0)=0.33
	SmoothingFactor=0.5
	SpinupTime=1.0
	Spread(0)=0.0
	MaxAmmo=30
	bLongRail=true
	bCannonMount=false
}
