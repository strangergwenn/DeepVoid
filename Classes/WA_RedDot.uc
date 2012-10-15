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
	IconPath="DV_Spacegear"
	Icon=Texture2D'DV_Spacegear.Icon.T_W_Todo'
	
	// Mesh
	Begin Object Name=AddonMesh
		StaticMesh=StaticMesh'DV_Addons.Mesh.SM_RedDot'
		Rotation=(Pitch=32768, Yaw=-16384, Roll=16384)
		Translation=(X=-0.2, Y=5.2, Z=0.1)
		Scale=1.65
	End Object
	
	// Properties
	SocketID=2
	bUseLens=false
	ZoomOffset=(X=2.00000,Y=30.000000,Z=0.000000)
}
