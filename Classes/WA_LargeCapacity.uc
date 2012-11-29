/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class WA_LargeCapacity extends DVWeaponAddon;


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Mesh
	Begin Object Name=AddonMesh
		StaticMesh=StaticMesh'DV_Addons.Mesh.SM_Ammo_Green'
		Rotation=(Yaw=-16384, Pitch=32768, Roll=16384)
		Scale=0.3
	End Object
	
	// Settings
	AmmoBonus=2.0
	SocketID=3
	IconPath="DV_Addons"
	Icon=Texture2D'DV_Addons.Icon.T_W_Todo'
}
