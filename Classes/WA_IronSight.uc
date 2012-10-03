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
		Rotation=(Pitch=32768, Yaw=-16384, Roll=16384)
		Translation=(Y=5.2)
		Scale=0.95
	End Object
	
	// Properties
	SocketID=2
	bUseLens=false
	ZoomOffset=(X=4.00000,Y=30.000000,Z=0.000000)
}
