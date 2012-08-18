/**
 *  This work is distributed under the General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class P_Pawn extends DVPawn;


/*----------------------------------------------------------
	Localized attributes
----------------------------------------------------------*/

var (DVPC) localized string			lRedFlagTaken;
var (DVPC) localized string			lBlueFlagTaken;
var (DVPC) localized string			lRedFlagDropped;
var (DVPC) localized string			lBlueFlagDropped;
var (DVPC) localized string			lRedFlagReturned;
var (DVPC) localized string			lBlueFlagReturned;
var (DVPC) localized string			lRedFlagCaptured;
var (DVPC) localized string			lBlueFlagCaptured;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var A_Flag							EnemyFlag;


/*----------------------------------------------------------
	Notifications
----------------------------------------------------------*/

/*--- Server flag state event ---*/
reliable server function ServerNotifyFlagState(int FlagState, byte TeamNumber)
{
	NotifyFlagState(FlagState, TeamNumber);
}

/*--- Client flag status - 0 : taken, 1 : dropped, 2 : returned, 3 : captured ---*/
reliable client simulated function NotifyFlagState(int FlagState, byte TeamNumber)
{
	local string message;
	
	switch (FlagState)
	{
		case 0:
			message = (TeamNumber == 0) ? lRedFlagTaken : lBlueFlagTaken;
			break;
		case 1:
			message = (TeamNumber == 0) ? lRedFlagDropped : lBlueFlagDropped;
			break;
		case 2:
			message = (TeamNumber == 0) ? lRedFlagReturned : lBlueFlagReturned;
			break;
		case 3:
			message = (TeamNumber == 0) ? lRedFlagCaptured : lBlueFlagCaptured;
			break;
	}
	
	DVPlayerController(Controller).ShowGenericMessage(message);
}


/*----------------------------------------------------------
	States
----------------------------------------------------------*/

/*--- Just before dying ---*/
simulated State Dying
{
	/*-- Flag drop ---*/
	simulated function BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		if (EnemyFlag != None && WorldInfo.NetMode == NM_DedicatedServer)
		{
			EnemyFlag.Drop(Controller);
			//TODO : detach flag
			if (WorldInfo.NetMode == NM_DedicatedServer)
				G_CaptureTheFlag(WorldInfo.Game).FlagTaken(EnemyFlag.TeamIndex);
		}
	}
}


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
	JumpSound=SoundCue'DV_Sound.Gameplay.A_Jump'
	HitSound=SoundCue'DV_Sound.Impacts.A_Impact_Player'
	TeamMaterials[0]=MaterialInstanceConstant'DV_Spacegear.Material.M_SpaceSuit_Red'
	TeamMaterials[1]=MaterialInstanceConstant'DV_Spacegear.Material.M_SpaceSuit_Blue'
}
