/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class G_TeamDeathmatch extends DVGame;


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Config
	MaxScore=50
	PointsForKill=1
	RestartTimer=10.0
	SpawnProtectTime=5.0
	DefaultPawnClass=class'P_Pawn'
	
	// Weapons (forbid optimizing out the classes)
	WeaponListLength=5
	DefaultWeapon=class'W_Rifle'
	DefaultWeaponList(0)=class'W_Rifle'
	DefaultWeaponList(1)=class'W_Sniper'
	DefaultWeaponList(2)=class'W_Shotgun'
	DefaultWeaponList(3)=class'W_EnergyGun'
	DefaultWeaponList(4)=class'W_GrenadeLauncher'
	
	// Order does not affect anything (forbid optimizing out the classes)
	DefaultAddonList(0)=class'WA_HeavyAmmo'
	DefaultAddonList(1)=class'WA_LargeCapacity'
	DefaultAddonList(2)=class'WA_LaserBeam'
	DefaultAddonList(3)=class'WA_Suppressor'
	DefaultAddonList(4)=class'WA_PenetratingAmmo'
	DefaultAddonList(5)=class'WA_RapidFire'
	DefaultAddonList(6)=class'WA_RedDot'
	DefaultAddonList(7)=class'WA_SniperSight'
	DefaultAddonList(8)=class'WA_IronSight'
}
