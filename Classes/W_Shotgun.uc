/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class W_Shotgun extends DVWeapon;


/*----------------------------------------------------------
	Attributes
----------------------------------------------------------*/

var float 	SpreadDist;


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Custom burst-fire ---*/
simulated function CustomFire()
{
   	local vector StartTrace, EndTrace, XDir, YDir, ZDir;
   	local rotator AimDir;
	local class<Projectile> ShardProjectileClass;
	local Projectile Proj;
	local float Mag;
	local int i,j;

	// Firing
	IncrementFlashCount();
	if (Role == ROLE_Authority)
	{
		// Traces
		StartTrace = InstantFireStartTrace();
		EndTrace = DVPlayerController(DVPawn(Owner).Controller).CurrentAimLocation;
		AimDir = rotator(EndTrace - StartTrace);
		GetAxes(AimDir, XDir, YDir, ZDir);

		// A shard in every direction
		ShardProjectileClass = GetProjectileClass();
		for ( i=-1; i<2; i++)
		{
			for ( j=-1; j<2; j++ )
			{
				Mag = (abs(i)+abs(j) > 1) ? 0.7 : 1.0;
				Proj = Spawn(ShardProjectileClass,,, StartTrace);
				if (Proj != None)
				{
					Proj.Init(Normal(vector(AimDir)) + (FRand())*Mag*i*SpreadDist*YDir + (FRand())*Mag*j*SpreadDist*ZDir );
				}
			}
	    }
	}
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Mesh
	Begin Object Name=WeaponMesh
		SkeletalMesh=SkeletalMesh'DV_Weapons.Mesh.SK_Shotgun'
		Translation=(X=3.0, Y=-2.0, Z=2.0)
		Scale=0.95
	End Object
	Mesh=WeaponMesh
	
	// Settings
	WeaponFireSnd[0]=SoundCue'DV_Sound.Weapons.A_ShotgunShot'
	WeaponEmptySound=SoundCue'DV_Sound.Weapons.A_Empty'
	ZoomOffset=(X=-1.0000,Y=40.000000,Z=0.000000)
	ZoomSensitivity=0.8
	SmoothingFactor=0.5
	ZoomedFOV=45

	// Recoil
	RecoilAngle=300
	
	// Interface
	WeaponIconPath="DV_Weapons"
	WeaponIcon=Texture2D'DV_Weapons.Icon.T_W_Shotgun'
	
	// Weaponry
	MuzzleFlashLightClass=class'DeepVoid.EL_Standard'
	WeaponProjectiles(0)=class'WP_ShotgunShell'
	WeaponFireTypes(0)=EWFT_Custom
	FireInterval(0)=0.6
	SpreadDist=0.03
	MaxAmmo=25
	bLongRail=true
	bCannonMount=false
}
