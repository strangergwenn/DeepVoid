/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class PU_StandardHealth extends DVPickup;


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (Health) int			HealthRechargeAmount;


/*----------------------------------------------------------
	States
----------------------------------------------------------*/

auto state Pickup
{
	function SpawnCopyFor(Pawn P)
	{
		DVPawn(P).AddHealth(HealthRechargeAmount);
		super.SpawnCopyFor(P);
	}

	function bool ValidTouch(Pawn Other)
	{
		local DVPlayerController PC;

		if (Other == None)
		{
			return false;
		}
		else if (Other.Controller == None)
		{
			SetTimer( 0.2, false, nameof(RecheckValidTouch) );
			return false;
		}
		else
		{
			PC = DVPlayerController(Other.Controller);
			return (DVPawn(PC.Pawn).Health < DVPawn(PC.Pawn).HealthMax);
		}
	}
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	Begin Object Name=BaseMeshComp
		StaticMesh=StaticMesh'DV_Spacegear.Mesh.SM_StandardAmmo'
		Translation=(Z=-50)
		Scale=0.18
	End Object
	
	Begin Object name=DynLightComponent
		LightColor=(R=50,G=250,B=10)
	End Object
	
	RespawnTime=5.0
	HealthRechargeAmount=20
	PickupSound=SoundCue'DV_Sound.Gameplay.A_Heal'
}
