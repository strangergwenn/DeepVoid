/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class WP_ShotgunShell extends DVProjectile;


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'VH_Manta.Effects.PS_Manta_Projectile'
	ProjExplosionTemplate=ParticleSystem'DV_CoreEffects.FX.PS_Impact''
	ExplosionSound=SoundCue'DV_Sound.Impacts.A_Impact_Plasma'
    MyDamageType=class'DamageType'
	
    bCollideWorld=true
    
    Damage=8
    Speed=15000
    DrawScale=1.0
    MaxSpeed=25000
    AccelRate=20000.0
    MomentumTransfer=10000
}
