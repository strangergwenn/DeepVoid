/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class W_Rifle extends DVWeapon;


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Mesh
	Begin Object Name=WeaponMesh
		SkeletalMesh=SkeletalMesh'DV_Weapons.Mesh.SK_Rifle'
		Translation=(X=3.0, Y=-2.0, Z=-0.5)
		Scale=0.95
	End Object
	Mesh=WeaponMesh
	
	// Settings
	ImpactEffect=(MaterialType=Water, ParticleTemplate=ParticleSystem'DV_CoreEffects.FX.PS_Impact')
	WeaponFireSnd[0]=SoundCue'DV_Sound.Weapons.A_RifleShot'
	WeaponEmptySound=SoundCue'DV_Sound.Weapons.A_Empty'
	SilencedWeaponSound=SoundCue'DV_Sound.Weapons.A_SniperShotSilenced'
	ZoomOffset=(X=-0.5000,Y=40.000000,Z=0.000000)
	ZoomSensitivity=0.7
	ZoomedFOV=45
	
	// Interface
	WeaponIconPath="DV_Weapons"
	WeaponIcon=Texture2D'DV_Weapons.Icon.T_W_Rifle'
	
	// Weaponry
	MuzzleFlashLightClass=class'DeepVoid.EL_Standard'
	InstantHitMomentum(0)=10000.0
	InstantHitDamage(0)=15.0
	FireInterval(0)=0.10
	SmoothingFactor=0.5
	Spread(0)=0.15
	MaxAmmo=40
	bLongRail=true
	bCannonMount=true
}
