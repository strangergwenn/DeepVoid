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
	function SpawnCopyFor(Pawn P)
	{
		DVPawn(P).AddWeaponAmmo(DVPawn(P).CurrentWeaponClass.default.MaxAmmo);
		super.SpawnCopyFor(P);
	}
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	Begin Object Name=BaseMeshComp
		StaticMesh=StaticMesh'DV_Spacegear.Mesh.SM_StandardAmmo'
		Translation=(Z=0)
		Scale=0.2
	End Object
	
	RespawnTime=5.0
	AmmoRechargeAmount=100
	PickupSound=SoundCue'DV_Sound.Gameplay.A_Heal'
}
