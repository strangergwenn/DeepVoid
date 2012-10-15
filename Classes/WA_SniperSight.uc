/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class WA_SniperSight extends DVWeaponAddon;


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
		StaticMesh=StaticMesh'DV_Addons.Mesh.SM_SniperSight'
		Rotation=(Yaw=-16384, Pitch=32768, Roll=16384)
		Scale=0.2
	End Object
	
	// Properties
	SocketID=2
	ZoomOffset=(X=1.500000,Y=-40.000000,Z=0.000000)
	SmoothingFactor=1.0
	ZoomSensitivity=0.3
	ZoomedFOV=20.0
	bUseLens=true
}
