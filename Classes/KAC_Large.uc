/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class KAC_Large extends KA_Cannister;


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultProperties
{
	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'Gas_bottle.Mesh.ST_PROPS_GasBottle_02'
		Scale=1.2
	End Object
	Begin Object Name=FireFX
		Translation=(Z=100)
		Rotation=(Pitch=16384)
	End Object
	BurnStrength=50.0
	BurnOrigin=(Z=100)
	BurnDir=(X=-1)
	BurnTime=4.5
}
