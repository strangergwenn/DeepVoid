/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/


class EL_Standard extends UDKExplosionLight;


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

defaultproperties
{
	HighDetailFrameTime=+0.02
	Brightness=10
	Radius=128
	LightColor=(R=255,G=255,B=255,A=255)
	TimeShift=((StartTime=0.0,Radius=256,Brightness=8,LightColor=(R=250,G=150,B=10,A=255)),(StartTime=0.2,Radius=64,Brightness=6,LightColor=(R=250,G=150,B=10,A=255)),(StartTime=0.25,Radius=64,Brightness=0,LightColor=(R=255,G=255,B=255,A=255)))
}
