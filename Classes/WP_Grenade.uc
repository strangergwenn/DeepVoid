/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class WP_Grenade extends DVProjectile;


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'VH_Manta.Effects.PS_Manta_Projectile'
	ProjExplosionTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketExplosion'
	ExplosionSound=SoundCue'DV_Sound.Impacts.A_Impact_Grenade'
    MyDamageType=class'DamageType'
	
    bCollideWorld=true
    
    Damage=45
    DamageRadius=300
    Speed=5000
    DrawScale=1.0
    MaxSpeed=10000
    AccelRate=15000.0
    MomentumTransfer=30000
}
