/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class W_Sniper extends W_Rifle;

/*----------------------------------------------------------
	Various methods
----------------------------------------------------------*/

/* --- Beam ---*/
reliable client simulated function bool UseBeam()
{
	return false;
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Settings
	WeaponFireSnd[0]=SoundCue'DV_Sound.Weapons.A_SniperShot'
	AddonClass1=class'WA_SniperSight'
	WeaponIconPath="DV_Spacegear"
	WeaponIcon=Texture2D'DV_Spacegear.Icon.T_W_Sniper'
	
	// Weaponry
	InstantHitMomentum(0)=40000.0
	InstantHitDamage(0)=100.0
	FireInterval(0)=1.0
	SmoothingFactor=1.0
	RecoilAngle=2000.0
	Spread(0)=0.0
	MaxAmmo=20
}
