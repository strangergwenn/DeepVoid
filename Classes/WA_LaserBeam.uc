/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class WA_LaserBeam extends DVWeaponAddon;


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (DVWeapon) const ParticleSystem		BeamPSCTemplate_Red;
var (DVWeapon) const ParticleSystem		BeamPSCTemplate_Blue;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var ParticleSystemComponent				BeamPSC;

var bool								bBeamActive;


/*----------------------------------------------------------
	Replication
----------------------------------------------------------*/

replication
{
	if ( bNetDirty )
		 bBeamActive;
}


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Weapon attachment ---*/
simulated function AttachToWeapon(DVWeapon wp)
{
	local DVPawn target;
	super.AttachToWeapon(wp);
	
	// Owner check
	if (wp.Owner.IsA('DVConfigBench'))
	{
		if (DVConfigBench(wp.Owner).PC == None)
			return;
		else
			target = DVPawn(DVConfigBench(wp.Owner).PC.Pawn);
	}
	else
	{
		target = DVPawn(wp.Owner);
	}
	if (target == None)
		return;
	
	// FX : beam
	BeamPSC = new(Outer) class'ParticleSystemComponent';
	BeamPSC.bAutoActivate = false;
	
	// Color
	if (DVPlayerRepInfo(target.PlayerReplicationInfo).Team.TeamIndex == 1)
		BeamPSC.SetTemplate(BeamPSCTemplate_Blue);
	else
		BeamPSC.SetTemplate(BeamPSCTemplate_Red);
	
	BeamPSC.bUpdateComponentInTick = true;
	BeamPSC.SetTickGroup(TG_EffectsUpdateWork);
	SkeletalMeshComponent(wp.Mesh).AttachComponentToSocket(BeamPSC, MountSocket());
}


/*--- Laser pointer end --*/
simulated function Tick(float DeltaTime)
{
	// Init
	local vector Impact, SL, Unused;
	local rotator SR;
	if (Weap == None)
		return;
	
	// Trace
	SkeletalMeshComponent(Weap.Mesh).GetSocketWorldLocationAndRotation(MountSocket(), SL, SR);
	Trace(
		Impact,
		Unused,
		SL + vector(SR) * 10000.0,
		SL,
		true,,, TRACEFLAG_Bullet
	);
	
	// Laser pointer update
	if (BeamPSC != None)
	{
		if (UseAddon() && !bBeamActive)
		{
			BeamPSC.ActivateSystem();
			bBeamActive = true;
		}
		else if (!UseAddon() && bBeamActive)
		{
			BeamPSC.DeactivateSystem();
			bBeamActive = false;
		}
		if (bBeamActive)
		{
			BeamPSC.SetVectorParameter('BeamEnd', VSize(Impact - SL) * vect(1,0,0));
		}
	}
}


/*--- Destroying ---*/
simulated function DetachFromWeapon(DVWeapon wp)
{
	if (BeamPSC != None)
	{
		BeamPSC.DeactivateSystem();
	}
	bBeamActive = false;
	super.DetachFromWeapon(wp);
}


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
		StaticMesh=StaticMesh'DV_Addons.Mesh.SM_LaserBeam'
		Rotation=(Yaw=0, Pitch=32768, Roll=16384)
		Translation=(X=-2)
		Scale=1.2
	End Object
	
	// Data
	SocketID=1
	bBeamActive=false
	BeamPSCTemplate_Blue=ParticleSystem'DV_CoreEffects.FX.PS_LaserBeamEffect_Blue'
	BeamPSCTemplate_Red=ParticleSystem'DV_CoreEffects.FX.PS_LaserBeamEffect'
}
