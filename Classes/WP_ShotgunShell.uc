/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class WP_ShotgunShell extends DVProjectile;


/*----------------------------------------------------------
	Methods
----------------------------------------------------------*/

/*--- Spawn a nice explosion effect ---*/
simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal)
{
	local vector x;
	if ( WorldInfo.NetMode != NM_DedicatedServer && EffectIsRelevant(Location,false,MaxEffectDistance) )
	{
		x = normal(Velocity cross HitNormal);
		x = normal(HitNormal cross x);

		WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplosionTemplate, HitLocation, rotator(x));
		bSuppressExplosionFX = true;
	}

	if (ExplosionSound!=None)
	{
		PlaySound(ExplosionSound);
	}
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'VH_Manta.Effects.PS_Manta_Projectile'
	ProjExplosionTemplate=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Beam_Impact'
	ExplosionSound=SoundCue'DV_Sound.Impacts.A_Impact_Shotgun'
    MyDamageType=class'DamageType'
	
    bCollideWorld=true
    
    Damage=7
    Speed=7000
    DrawScale=1.0
    MaxSpeed=15000
    AccelRate=20000.0
    MomentumTransfer=5000
}
