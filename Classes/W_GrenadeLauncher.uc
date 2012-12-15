/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class W_GrenadeLauncher extends DVWeapon;


/*----------------------------------------------------------
	Firing
----------------------------------------------------------*/

/*--- Muzzle flash ---*/
simulated function PlayFiringEffects(vector HitLocation)
{
	MuzzleFlashPSC.ActivateSystem();
	SkeletalMeshComponent(Mesh).PlayAnim('Fire',,false,true,,true);
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Animation
	Begin Object class=AnimNodeSequence Name=MyMeshSequence
	End Object
	
	// Mesh
	Begin Object Name=WeaponMesh
		Animations=MyMeshSequence
		SkeletalMesh=SkeletalMesh'DV_Weapons.Mesh.SK_GrenadeLauncher'
		AnimSets.Add(AnimSet'DV_Weapons.Mesh.K_GrenadeLauncher')
		Translation=(X=4.0, Y=-2.0, Z=2.0)
		Scale=0.95
	End Object
	Mesh=WeaponMesh
	
	// Settings
	WeaponFireSnd[0]=SoundCue'DV_Sound.Weapons.A_GrenadeLauncherShot'
	WeaponEmptySound=SoundCue'DV_Sound.Weapons.A_Empty'
	ZoomOffset=(X=-1.0000,Y=40.000000,Z=0.000000)
	ZoomSensitivity=0.8
	SmoothingFactor=0.5
	ZoomedFOV=45
	
	// Interface
	WeaponIconPath="DV_Weapons"
	WeaponIcon=Texture2D'DV_Weapons.Icon.T_W_GrenadeLauncher'
	
	// Weaponry
	WeaponProjectiles(0)=class'WP_Grenade'
	WeaponFireTypes(0)=EWFT_Projectile
	FireInterval(0)=1.0
	MaxAmmo=15
	bLongRail=false
	bCannonMount=false
}
