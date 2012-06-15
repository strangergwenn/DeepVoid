/**
 *  This work is distributed under the General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class P_Pawn extends DVPawn;


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Main mesh
	Begin Object Name=SkeletalMeshComponent0
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_AimOffset'
		AnimSets(1)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		SkeletalMesh=SkeletalMesh'DV_Spacegear.Mesh.SK_SpaceSuit'
	End Object
	
	// Set to true for heatmap logs
	//bDVLog=true
	
	// Gameplay
	JumpZ=620.0
	AirSpeed=850.0
	AirControl=0.2
	MaxJumpHeight=100.0
	ZoomedGroundSpeed=300
	UnzoomedGroundSpeed=750
	HeadshotMultiplier=1.5
	JumpDamageMultiplier=1.1
	
	// Eyes
	StandardEyeHeight=70.0
	HeadBobbingFactor=0.8
	RecoilLength=7000.0
	CrouchHeight=70.0
	
	// External data
	ModuleName="DeepVoid"
	FootStepSound=SoundCue'DV_Sound.Gameplay.A_Walk'
	HitSound=SoundCue'DV_Sound.Impacts.A_Impact_Player'
	TeamMaterials[0]=MaterialInstanceConstant'DV_Spacegear.Material.M_SpaceSuit_Red'
	TeamMaterials[1]=MaterialInstanceConstant'DV_Spacegear.Material.M_SpaceSuit_Blue'
}
