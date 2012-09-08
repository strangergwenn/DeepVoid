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

var (TargetControl) const Color 		TextColor;
var (TargetControl) const LinearColor 	ClearColor;

var (TargetControl) const float 		TextScale;
var (TargetControl) const float			TextOffsetX;
var (TargetControl) const float			TextOffsetY;

var (TargetControl) const float			MaxTargetInterval;

var (TargetControl) const int			MaxTargetToShoot;


/*----------------------------------------------------------
	Localized attributes
----------------------------------------------------------*/

var (TargetControl) localized string	lPoints;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var ScriptedTexture						CanvasTexture;
var MaterialInterface 					PanelMaterialTemplate;

var StaticMeshComponent					Mesh;

var array<A_Target>						TargetList;

var string				 				PanelText;
var name 								CanvasTextureParamName;

var float								OverallTime;

var int									TargetsShot;
var int 								PanelMaterialIndex;


/*----------------------------------------------------------
	Display code
----------------------------------------------------------*/

/*--- Initial setup ---*/
function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(FRand() * MaxTargetInterval, false, 'RaiseTarget');
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


/*--- Rendering method ---*/
function OnRender(Canvas C)
{		
	C.SetOrigin(TextOffsetX, TextOffsetY);
	
	if (PanelText != "")
	{
		C.SetPos(0, 0);
		C.SetDrawColorStruct(TextColor);
		C.DrawText("" $ (1.0 / OverallTime) @lPoints,, TextScale, TextScale);
	}
	
	CanvasTexture.bNeedsUpdate = true;
}


/*----------------------------------------------------------
	Targeting methods
----------------------------------------------------------*/

/*--- New target is ready to use ---*/
simulated function RegisterTarget(A_Target trg)
{
	TargetList.AddItem(trg);
	`log("ATM > RegisterTarget" @trg @self);
}


/*--- Raise a random (non-raised) target ---*/
simulated function RaiseTarget()
{
	local A_Target trg;
	`log("ATM > RaiseTarget" @self);
	
	// Activate the target
	do
	{
		trg = TargetList[Rand(TargetList.Length)];
	}
	until (trg.bAlive);
	trg.ActivateTarget();
	
	// Moar !
	if (TargetsShot < MaxTargetToShoot)
	{
		AllTargetsShots();
		ClearTimer('RaiseTarget');
	}
	else
	{
		SetTimer(FRand() * MaxTargetInterval, false, 'RaiseTarget');
	}
}


/*--- Target shot or auto-deactivated ---*/
simulated function TargetDown(A_Target trg, float TimeAlive, bool bWasShot)
{
	`log("ATM > TargetKilled" @trg @TimeAlive @self);
	
	if (bWasShot)
	{
		TargetsShot += 1;
	}
	
	OverallTime += TimeAlive;
}


/*--- End of game ---*/
simulated function AllTargetsShots()
{
	`log("ATM > AllTargetsShots in" @OverallTime @self);
	
	// TODO END SCORE
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Gameplay
	MaxTargetInterval=2.0
	MaxTargetToShoot=30
	TextScale=10.0
	TextOffsetX=0.0
	TextOffsetY=0.0
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
	End Object
	Mesh=MyStaticMeshComponent
 	Components.Add(MyStaticMeshComponent)
	CollisionComponent=MyStaticMeshComponent
	
	// Physics
	Physics=PHYS_RigidBody
	bEdShouldSnap=true
	bCollideActors=true
	bCollideWorld=true
	bBlockActors=true
	bPathColliding=true
}
