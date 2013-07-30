/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class A_FlagBase extends UDKGameObjective
	placeable
	ClassGroup(DeepVoid)
	hidecategories(Collision, Physics);


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (Flag) const byte 			TeamIndex;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var StaticMeshComponent			Mesh;

var A_Flag						OwnedFlag;

replication
{
	if (bNetDirty)
		TeamIndex, Mesh, OwnedFlag;
}


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Game startup ---*/
simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	// CTF specific
	if (G_CaptureTheFlag(WorldInfo.Game) != None)
	{
		`log("AF > PostBeginPlay" @self);
		SpawnFlag();
	}
}


/*--- (Re)spawn the flag ---*/
simulated function SpawnFlag()
{
	if (Role >= ROLE_Authority && G_CaptureTheFlag(WorldInfo.Game) != None)
	{
		OwnedFlag = Spawn(class'A_Flag', self);
		OwnedFlag.SetFlagData(TeamIndex, self);
		`log("AFB > Flag spawned" @OwnedFlag @self);
	}
}


/*--- Our flag was returned ---*/
simulated function FlagReturned()
{
	`log("AFB > Flag returned" @self);
	if (WorldInfo.NetMode == NM_DedicatedServer)
	{
		G_CaptureTheFlag(WorldInfo.Game).FlagReturned(TeamIndex);
	}
	SpawnFlag();
}


/*--- Our flag was captured ---*/
simulated function FlagCaptured()
{
	`log("AFB > Flag captured" @self);
	if (WorldInfo.NetMode == NM_DedicatedServer)
	{
		G_CaptureTheFlag(WorldInfo.Game).FlagCaptured(TeamIndex);
	}
	SpawnFlag();
}


/*--- Safety tick ---*/
simulated function Tick(float DeltaTime)
{
	if (G_CaptureTheFlag(WorldInfo.Game) != None)
	{
		if (OwnedFlag == None)
		{
			SetTimer(3.0, false, 'CheckFlag');
			`log("AFB > Flag respawn timer is started" @self);
		}
	}
}


/*--- Something went very wrong ---*/
reliable server simulated function CheckFlag()
{
	if (OwnedFlag == None)
	{
		`log("AFB > Flag respawn on timeout" @self);
		SpawnFlag();
	}
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultProperties
{
	// Lighting
	Begin Object class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
		bDynamic=true
	End Object
	Components.Add(MyLightEnvironment)
	
	// Mesh
	Begin Object class=StaticMeshComponent name=GroundBase		
		BlockActors=true
		CollideActors=true
		BlockRigidBody=true
		BlockZeroExtent=true
		BlockNonzeroExtent=true
		
		CastShadow=false
		bAcceptsLights=true
		bCastDynamicShadow=false
		bForceDirectLightMap=true
		LightEnvironment=MyLightEnvironment
		
		Scale=0.4
		Translation=(X=-40.0,Y=0.0,Z=-48.0)
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		StaticMesh=StaticMesh'DV_Gameplay.Mesh.SM_Base'
		
	End Object
	CollisionComponent=GroundBase
	Components.Add(GroundBase)
	Mesh=GroundBase
	
	// Networking
	bStatic=false
	bHidden=false
	bAlwaysRelevant=true
	bTickIsDisabled=false
	NetUpdateFrequency=1
	RemoteRole=ROLE_SimulatedProxy
	
 	// Mesh settings
	bEdShouldSnap=true
	bCollideActors=true
	bCollideWorld=true
	bBlockActors=true
	bPathColliding=true
}
