/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class WA_IronSight extends DVWeaponAddon;


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
		StaticMesh=StaticMesh'DV_Spacegear.Mesh.SM_IronSight'
		Rotation=(Yaw=-16384, Pitch=32768)
		Scale=0.95
	End Object
	
	// Properties
	SocketID=2
	ZoomedFOV=20.0
	bUseLens=false
}
