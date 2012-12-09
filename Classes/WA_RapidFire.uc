/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class WA_RapidFire extends DVWeaponAddon;


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
		StaticMesh=StaticMesh'DV_Addons.Mesh.SM_RailVent'
		Rotation=(Yaw=32768, Pitch=32768, Roll=-16384)
		Translation=(X=-0.7, Y=0.0, Z=0.5)
		Scale=0.6
	End Object
	
	// Settings
	FireRateBonus=1.1
	SocketID=1
	bRequiresCannonMount=true
	IconPath="DV_Addons"
	Icon=Texture2D'DV_Addons.Icon.T_WA_RapidFire'
}
