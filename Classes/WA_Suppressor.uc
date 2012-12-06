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
		StaticMesh=StaticMesh'DV_Addons.Mesh.SM_Silencer'
		Rotation=(Yaw=0, Pitch=-16384, Roll=16384)
		Translation=(X=-35.0, Y=-2.7, Z=0.0)
		Scale=2.0
	End Object
	
	// Settings
	PrecisionBonus=2.0
	SocketID=1
	bSilenced=true
	bCannonMount=false
	IconPath="DV_Addons"
	Icon=Texture2D'DV_Addons.Icon.T_W_Todo'
}
