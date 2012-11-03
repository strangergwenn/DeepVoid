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
		Rotation=(Yaw=-16384, Pitch=-16384, Roll=16384)
		Translation=(X=-5.5, Y=-9.0, Z=0.0)
		Scale=2.0
	End Object
	
	// Properties
	SocketID=2
	ZoomOffset=(X=1.500000,Y=-40.000000,Z=0.000000)
	SmoothingFactor=1.0
	ZoomSensitivity=0.3
	ZoomedFOV=20.0
	bUseLens=true
}
