/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class WA_Torchlight extends DVWeaponAddon;


/*----------------------------------------------------------
	Private data
----------------------------------------------------------*/

var bool							bFlashLightActive;
var SpotLightComponent				FlashLight;


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Weapon attachment ---*/
simulated function Tick(float DeltaTime)
{
	// Init
	if (Weap == None || Weap.Mesh == None)
	{
		return;
	}
	else if (UseAddon() && !bFlashLightActive)
	{
		SkeletalMeshComponent(Weap.Mesh).AttachComponentToSocket(FlashLight, MountSocket());
		bFlashLightActive = true;
	}
	else if (!UseAddon() && bFlashLightActive)
	{
        SkeletalMeshComponent(Weap.Mesh).DetachComponent(FlashLight);
		bFlashLightActive = false;
	}
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Interface
	SocketID=1
	bFlashLightActive=false
	IconPath="DV_Addons"
	Icon=Texture2D'DV_Addons.Icon.T_WA_Laser'
	
    Begin Object Class=SpotLightComponent Name=TorchLightComponent1
        InnerConeAngle=10.000000
        OuterConeAngle=20.000000
        Radius=2500.000000
        Brightness=4.000000
        LightColor=(B=180,G=240,R=255,A=0)
        LightShadowMode = LightShadow_Normal
        ShadowFilterQuality = SFQ_High
        ShadowProjectionTechnique = ShadowProjTech_Default
    End Object
    Flashlight=TorchLightComponent1

	// Mesh
	Begin Object Name=AddonMesh
		StaticMesh=StaticMesh'DV_Addons.Mesh.SM_LaserBeam'
		Rotation=(Yaw=16384, Pitch=-16384, Roll=0)
		Translation=(X=-15.000000,Y=1.000000,Z=-1.000000)
		Scale=1.5
	End Object
}
