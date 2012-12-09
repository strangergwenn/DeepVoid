/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class WA_HeavyAmmo extends DVWeaponAddon;


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Mesh
	Begin Object Name=AddonMesh
		StaticMesh=StaticMesh'DV_Addons.Mesh.SM_AmmoUpgrade_3'
		Rotation=(Yaw=-16384, Pitch=-16384, Roll=16384)
		Translation=(X=0.5, Y=11.0, Z=0.0)
		Scale=2.0
	End Object
	
	// Settings
	KineticBonus=10.0
	SocketID=3
	IconPath="DV_Addons"
	Icon=Texture2D'DV_Addons.Icon.T_WA_HeavyAmmo'
}
