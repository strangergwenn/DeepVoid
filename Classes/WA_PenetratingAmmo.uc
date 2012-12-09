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
		StaticMesh=StaticMesh'DV_Addons.Mesh.SM_AmmoUpgrade_1'
		Rotation=(Yaw=-16384, Pitch=-16384, Roll=16384)
		Translation=(X=0.0, Y=6.0, Z=0.0)
		Scale=1.5
	End Object
	
	// Properties
	DamageBonus=1.1
	SocketID=3
	IconPath="DV_Addons"
	Icon=Texture2D'DV_Addons.Icon.T_WA_PenetratingAmmo'
}
