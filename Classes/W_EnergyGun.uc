/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class W_EnergyGun extends W_Rifle;


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Settings
	WeaponFireSnd[0]=SoundCue'DV_Sound.Weapons.A_SniperShot'
	WeaponIconPath="DV_Spacegear"
	WeaponIcon=Texture2D'DV_Spacegear.Icon.T_W_Sniper'
	
	// Weaponry
	AddonClass1=class'WA_LaserBeam'
	InstantHitMomentum(0)=40000.0
	InstantHitDamage(0)=40.0
	FireInterval(0)=0.33
	SmoothingFactor=1.0
	RecoilAngle=500.0
	Spread(0)=0.0
	MaxAmmo=50
}
