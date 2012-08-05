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
		StaticMesh=StaticMesh'DV_Spacegear.Mesh.SM_Ammo_Red'
		Rotation=(Yaw=-16384, Pitch=32768, Roll=16384)
		Scale=0.3
	End Object
	
	// Properties
	DamageBonus=1.1//TODO
	SocketID=3
	IconPath="DV_Spacegear"
	Icon=Texture2D'DV_Spacegear.Icon.T_W_Todo'
}
