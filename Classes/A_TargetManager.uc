/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class A_TargetManager extends Actor
	HideCategories(Display,Collision,Physics)
	ClassGroup(DeepVoid)
	placeable;


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (TargetControl) MaterialInstanceConstant PanelMaterial;

var (TargetControl) DVButton			Trigger;

var (TargetControl) const float 		TextScale;
var (TargetControl) const float			TextOffsetX;
var (TargetControl) const float			TextOffsetY;

var (TargetControl) const float			MinTargetInterval;
var (TargetControl) const float			MaxTargetInterval;
var (TargetControl) const float			MinTargetLife;
var (TargetControl) const float			MaxTargetLife;
var (TargetControl) const float			ScoreMultiplier;

var (TargetControl) const int			MaxTargetToShoot;


/*----------------------------------------------------------
	Localized attributes
----------------------------------------------------------*/

var (TargetControl) localized string	lPoints;
var (TargetControl) localized string	lSeconds;
var (TargetControl) localized string	lKills;
var (TargetControl) localized string	lShots;
var (TargetControl) localized string	lHeadshots;
var (TargetControl) localized string	lPrecision;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var Color 								TextColor;
var const LinearColor 					ClearColor;

var ScriptedTexture						CanvasTexture;
var MaterialInterface 					PanelMaterialTemplate;
var StaticMeshComponent					Mesh;

var array<A_Target>						TargetList;
var DVPlayerController					PC;

var string				 				PanelText;
var name 								CanvasTextureParamName;

var float								OverallTime;

var int									ShotsFired;
var int									TargetsShot;
var int									HeadshotCount;
var int									ShotsFiredOnStart;
var int 								PanelMaterialIndex;

var bool 								bGameStarted;
var bool 								bGameEnded;


/*----------------------------------------------------------
	Display code
----------------------------------------------------------*/

/*--- Initial setup ---*/
function PostBeginPlay()
{
	super.PostBeginPlay();
	CanvasTexture = ScriptedTexture(class'ScriptedTexture'.static.Create(1024, 1024,, ClearColor));
	CanvasTexture.Render = OnRender;
	
	// Material setup
	if (PanelMaterialTemplate != None)
	{
		PanelMaterial = Mesh.CreateAndSetMaterialInstanceConstant(PanelMaterialIndex);
		if (PanelMaterial != none)
		{
			PanelMaterial.SetParent(PanelMaterialTemplate);
			if (CanvasTextureParamName != '')
			{
				PanelMaterial.SetTextureParameterValue(CanvasTextureParamName, CanvasTexture);
			}
		}
	}
}


/*--- Launch the game ---*/
function StartGame()
{
	local DVPlayerController LocalPC;
	OverallTime = 0.0;
	TargetsShot = 0;
	HeadshotCount = 0;
	bGameEnded = false;
	bGameStarted = true;

	// Get a PC	
	foreach AllActors(class'DVPlayerController', LocalPC)
	{
		PC = LocalPC;
		ShotsFiredOnStart = PC.LocalStats.ShotsFired;
		`log("ATM > Got PC" @PC $"," @ShotsFiredOnStart @"on start");
	}
	
	SetTimer(FRand() * MaxTargetInterval, false, 'RaiseTarget');
}


/*--- Detection tick ---*/
simulated function Tick(float DeltaTime)
{
	// Startup
	if (Trigger != None && !bGameStarted)
	{
		if (Trigger.bIsActivated)
		{
			StartGame();
		}
	}
	
	// If there is a player... 
	if (PC != None)
	{
		// Shots
		if (!bGameEnded)
		{
			ShotsFired = PC.GlobalStats.ShotsFired - ShotsFiredOnStart;
		}
		PanelText = TargetsShot @lKills @"-" @ShotsFired @lShots $"\n";
		PanelText $= round((TargetsShot * 100) / ShotsFired) $"%" @lPrecision $"\n";
		PanelText $= HeadshotCount @lHeadshots $"\n";
		
		// Time
		PanelText $= OverallTime @lSeconds $"\n";
		
		// Score
		if (bGameEnded)
		{
			PanelText $= "\n> ";
			PanelText $= round(
				(1 + HeadshotCount / MaxTargetToShoot + TargetsShot / ShotsFired)
				* ScoreMultiplier 
				/ OverallTime
			);
			PanelText $= " " $ lPoints;
		}
	}
}


/*--- Rendering method ---*/
function OnRender(Canvas C)
{	
	C.SetOrigin(TextOffsetX, TextOffsetY);
	C.SetPos(0, 0);
	C.SetDrawColorStruct(TextColor);
	C.DrawText(PanelText,, TextScale, TextScale);
	CanvasTexture.bNeedsUpdate = true;
}


/*----------------------------------------------------------
	Targeting methods
----------------------------------------------------------*/

/*--- New target is ready to use ---*/
simulated function RegisterTarget(A_Target trg)
{
	trg.MinLife = MinTargetLife;
	trg.MaxLife = MaxTargetLife;
	TargetList.AddItem(trg);
}


/*--- Raise a random (non-raised) target ---*/
simulated function RaiseTarget()
{
	local A_Target trg;
	
	// Moar !
	if (TargetsShot >= MaxTargetToShoot)
	{
		AllTargetsShots();
		ClearTimer('RaiseTarget');
	}
	else
	{
		// Activate the target
		do
		{
			trg = TargetList[Rand(TargetList.Length)];
		}
		until (!trg.bAlive);
		trg.ActivateTarget();
		SetTimer(MinTargetInterval + FRand() * MaxTargetInterval, false, 'RaiseTarget');
	}
}


/*--- Target shot or auto-deactivated ---*/
simulated function TargetDown(A_Target trg, float TimeAlive, bool bWasShot, bool bHeadshot)
{	
	if (bWasShot)
	{
		TargetsShot += 1;
	}
	
	if (bHeadshot)
	{
		HeadshotCount += 1;
	}
	
	OverallTime += TimeAlive;
}


/*--- End of game ---*/
simulated function AllTargetsShots()
{
	`log("ATM > AllTargetsShots in" @OverallTime @self);
	Trigger.DeActivate();
	bGameEnded = true;
	bGameStarted = false;
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Gameplay
	ScoreMultiplier=40000
	MinTargetInterval=0.5
	MaxTargetInterval=1.5
	MaxTargetToShoot=20
	MinTargetLife=0.5
	MaxTargetLife=3.0
	OverallTime=0.001
	
	// Text
	PanelMaterialTemplate=Material'DV_Spacegear.Material.M_PanelText'
	CanvasTextureParamName=CanvasTexture
	TextScale=4.0
	TextOffsetX=50.0
	TextOffsetY=500.0
	ClearColor=(R=0.0,G=0.0,B=0.0,A=0.0)
	TextColor=(R=255,G=255,B=255,A=255)
	
	// Light
	Begin Object class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
		bDynamic=true
	End Object
	Components.Add(MyLightEnvironment)

	// Mesh
	Begin Object class=StaticMeshComponent Name=MyStaticMeshComponent
		LightEnvironment=MyLightEnvironment
		BlockActors=true
		BlockZeroExtent=true
		BlockRigidBody=true
		BlockNonzeroExtent=true
		CollideActors=true
		StaticMesh=StaticMesh'DV_Spacegear.Mesh.SM_TargetManager'
	End Object
	Mesh=MyStaticMeshComponent
 	Components.Add(MyStaticMeshComponent)
	CollisionComponent=MyStaticMeshComponent
	
	// Physics
	bEdShouldSnap=true
	bCollideActors=true
	bCollideWorld=true
	bBlockActors=true
	bPathColliding=true
}
