/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class PC_PlayerController extends DVPlayerController;


/*----------------------------------------------------------
	CTF methods
----------------------------------------------------------*/

/*--- Object activation ---*/
exec function Activate()
{
	Super.Activate();
	if (IsChatLocked() || bConfiguring)
	{
		return;
	}

	// Drop the flag
	if (P_Pawn(Pawn).EnemyFlag != None)
	{
		P_Pawn(Pawn).ServerDropFlag();
	}
}
