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
	MaxScore=50
	RestartTimer=10.0
	DefaultPawnClass=class'P_Pawn'
	DefaultTurretClass=class'T_DefensiveTurret'
	
	WeaponListLength=5
	DefaultWeapon=class'W_Rifle'
	DefaultWeaponList(0)=class'W_Rifle'
	DefaultWeaponList(1)=class'W_Sniper'
	DefaultWeaponList(2)=class'W_Shotgun'
	DefaultWeaponList(3)=class'W_EnergyGun'
	DefaultWeaponList(4)=class'W_GrenadeLauncher'
}
