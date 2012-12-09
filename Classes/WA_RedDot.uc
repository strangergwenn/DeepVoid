/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class WA_RedDot extends DVWeaponAddon;


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Interface
	IconPath="DV_Addons"
	Icon=Texture2D'DV_Addons.Icon.T_WA_Reddot'
	
	// Mesh
	Begin Object Name=AddonMesh
		StaticMesh=StaticMesh'DV_Addons.Mesh.SM_RedDot'
		Rotation=(Pitch=32768, Yaw=-16384, Roll=16384)
		Translation=(X=-0.2, Y=5.0, Z=0)
		Scale=1.65
	End Object
	
	// Properties
	SocketID=2
	bUseLens=false
	ZoomedFOV=30.0
	ZoomOffset=(X=2.4000,Y=25.000000,Z=0.000000)
}
