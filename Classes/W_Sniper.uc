/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class W_Sniper extends DVWeapon;


/*----------------------------------------------------------
	Properties 
----------------------------------------------------------*/

defaultproperties
{
	// Mesh
	Begin Object Name=WeaponMesh
		SkeletalMesh=SkeletalMesh'DV_Weapons.Mesh.SK_SniperRifle'
		Translation=(X=3.0, Y=-2.0, Z=1.0)
		Scale=0.95
	End Object
	Mesh=WeaponMesh
	
	// Settings
	ImpactEffect=(MaterialType=Water, ParticleTemplate=ParticleSystem'DV_CoreEffects.FX.PS_Impact')
	ImpactEffectDyn=(MaterialType=Water, ParticleTemplate=ParticleSystem'DV_CoreEffects.FX.PS_ImpactDyn')
	WeaponFireSnd[0]=SoundCue'DV_Sound.Weapons.A_SniperShot'
	WeaponEmptySound=SoundCue'DV_Sound.Weapons.A_Empty'
	SilencedWeaponSound=SoundCue'DV_Sound.Weapons.A_SniperShotSilenced'
	ZoomOffset=(X=-1.0000,Y=40.000000,Z=0.000000)
	ZoomSensitivity=0.7
	ZoomedFOV=45

	// Recoil
	RecoilAngle=70
	
	// Interface
	WeaponIconPath="DV_Weapons"
	WeaponIcon=Texture2D'DV_Weapons.Icon.T_W_Sniper'
	
	// Weaponry
	MuzzleFlashLightClass=class'DeepVoid.EL_Standard'
	InstantHitMomentum(0)=40000.0
	InstantHitDamage(0)=90.0
	FireInterval(0)=1.0
	SmoothingFactor=1.0
	Spread(0)=0.0
	MaxAmmo=25
	bLongRail=true
}
