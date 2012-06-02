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
		SkeletalMesh=SkeletalMesh'DV_Spacegear.Mesh.SK_Rifle'
	End Object
	Mesh=WeaponMesh
	
	// Settings
	ImpactEffect=(MaterialType=Water, ParticleTemplate=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Beam_Impact')
	WeaponFireSnd[0]=SoundCue'DV_Sound.Weapons.A_RifleShot'
	WeaponEmptySound=SoundCue'DV_Sound.Weapons.A_Empty'
	ZoomOffset=(X=1.50000,Y=23.000000,Z=0.000000)
	ZoomSensitivity=0.7
	ZoomedFOV=45
	
	// Interface
	WeaponIconPath="DV_Spacegear"
	WeaponIcon=Texture2D'DV_Spacegear.Icon.T_W_Rifle'
	
	// Weaponry
	AddonClass1=class'WA_LaserBeam'
	InstantHitMomentum(0)=10000.0
	InstantHitDamage(0)=15.0
	FireInterval(0)=0.10
	SmoothingFactor=0.9
	RecoilAngle=300.0
	Spread(0)=0.15
	MaxAmmo=75
}
