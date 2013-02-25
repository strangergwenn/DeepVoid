/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class PU_StandardAmmo extends DVPickup;


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (Ammo) int			AmmoRechargeAmount;


/*----------------------------------------------------------
	States
----------------------------------------------------------*/

auto state Pickup
{
	simulated function SpawnCopyFor(Pawn P)
	{
		DVPawn(P).AddWeaponAmmo(AmmoRechargeAmount);
		super.SpawnCopyFor(P);
	}

	simulated function bool ValidTouch(Pawn Other)
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
			return (PC.GetAmmoCount() != PC.GetAmmoMax());
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
	
	RespawnTime=5.0
	AmmoRechargeAmount=1000
	PickupSound=SoundCue'DV_Sound.Gameplay.A_Heal'
}
