/**
 *  This work is distributed under the General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class T_DefensiveTurret extends DVTurret;


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	// Mesh
	Begin Object name=TurretMesh
		SkeletalMesh=SkeletalMesh'Tower.Mesh.SK_BasicTower'
		AnimTreeTemplate=AnimTree'Tower.Anim.AT_BasicTower'
		PhysicsAsset=PhysicsAsset'Tower.Mesh.SK_BasicTower_Physics'
		Materials[0]=Material'Tower.Material.M_BasicTower'
	End Object
	
	// Settings
	RoundsPerSec=11.0
	MinTurretRotRate=100000
	MaxTurretRotRate=300000
	ProjClass=class'WP_ShotgunShell'
	FireSound=SoundCue'DV_Sound.Weapons.A_RifleShot'
	MuzzleFlashEmitter=ParticleSystem'DV_CoreEffects.FX.PS_Flash',
}
