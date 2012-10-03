/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class WA_Suppressor extends DVWeaponAddon;


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

/*--- Override positionning ---*/
simulated function name MountSocket()
{
	return name("MF");
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Mesh
	Begin Object Name=AddonMesh
		StaticMesh=StaticMesh'DV_Spacegear.Mesh.SM_LongCannon'
		Rotation=(Yaw=0, Pitch=32768, Roll=16384)
	End Object
	
	// Settings
	PrecisionBonus=2.0
	SocketID=1
	IconPath="DV_Spacegear"
	Icon=Texture2D'DV_Spacegear.Icon.T_W_Todo'
}
