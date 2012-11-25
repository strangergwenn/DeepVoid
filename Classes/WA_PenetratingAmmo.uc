/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class WA_PenetratingAmmo extends DVWeaponAddon;


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Mesh
	Begin Object Name=AddonMesh
		StaticMesh=StaticMesh'DV_Addons.Mesh.SM_Ammo_Red'
		Rotation=(Yaw=-16384, Pitch=32768, Roll=16384)
		Scale=0.3
	End Object
	
	// Properties
	DamageBonus=1.1
	SocketID=3
	IconPath="DV_Addons"
	Icon=Texture2D'DV_Addons.Icon.T_W_Todo'
}
