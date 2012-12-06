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
	
	// Addons (forbid optimizing out the classes)
	DefaultAddonList(0)=class'WA_HeavyAmmo'
	DefaultAddonList(1)=class'WA_LargeCapacity'
	DefaultAddonList(2)=class'WA_LaserBeam'
	DefaultAddonList(3)=class'WA_Suppressor'
	DefaultAddonList(4)=class'WA_PenetratingAmmo'
	DefaultAddonList(5)=class'WA_RapidFire'
	DefaultAddonList(6)=class'WA_RedDot'
	DefaultAddonList(7)=class'WA_SniperSight'
	DefaultAddonList(8)=class'WA_IronSight'
	
	// Weapon icons (forbid optimizing out the textures)
	DefaultIconList(0)=Material'DV_Weapons.Icon.T_W_Rifle_Mat'
	DefaultIconList(1)=Material'DV_Weapons.Icon.T_W_Shotgun_Mat'
	DefaultIconList(2)=Material'DV_Weapons.Icon.T_W_Sniper_Mat'
	DefaultIconList(3)=Material'DV_Weapons.Icon.T_W_EnergyGun_Mat'
	DefaultIconList(4)=Material'DV_Weapons.Icon.T_W_GrenadeLauncher_Mat'
	DefaultIconList(5)=Material'DV_Weapons.Icon.T_W_Todo_Mat'
	
	// Add-on icons (forbid optimizing out the textures)
	DefaultIconList(6)=Material'DV_Addons.Icon.T_WA_HeavyAmmo_Mat'
	DefaultIconList(7)=Material'DV_Addons.Icon.T_WA_IronSight_Mat'
	DefaultIconList(8)=Material'DV_Addons.Icon.T_WA_LargeCapacity_Mat'
	DefaultIconList(9)=Material'DV_Addons.Icon.T_WA_LaserPointer_Mat'
	DefaultIconList(10)=Material'DV_Addons.Icon.T_WA_PenetratingAmmo_Mat'
	DefaultIconList(11)=Material'DV_Addons.Icon.T_WA_RapidFire_Mat'
	DefaultIconList(12)=Material'DV_Addons.Icon.T_WA_Reddot_Mat'
	DefaultIconList(13)=Material'DV_Addons.Icon.T_WA_Silencer_Mat'
	DefaultIconList(14)=Material'DV_Addons.Icon.T_W_Todo_Mat'
}
