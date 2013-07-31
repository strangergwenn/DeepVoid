/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class G_CaptureTheFlag extends G_TeamDeathmatch;


/*----------------------------------------------------------
	Game events
	Flag status : 0 : taken, 1 : dropped, 2 : returned
----------------------------------------------------------*/


/*--- The flag was taken : advertise that to everyone ---*/
function FlagTaken (byte FlagTeamNumber)
{
	NotifyAllPawns(0, FlagTeamNumber);
	`log("DVCTF > FlagTaken" @FlagTeamNumber);
}


/*--- The flag was dropped ---*/
function FlagDropped (byte FlagTeamNumber)
{
	NotifyAllPawns(1, FlagTeamNumber);
	`log("DVCTF > FlagDropped" @FlagTeamNumber);
}


/*--- The flag was returned ---*/
function FlagReturned (byte FlagTeamNumber)
{
	NotifyAllPawns(2, FlagTeamNumber);
	`log("DVCTF > FlagReturned" @FlagTeamNumber);
}


/*--- The flag was captured ---*/
function FlagCaptured (byte FlagTeamNumber)
{
	NotifyAllPawns(3, FlagTeamNumber);
	Teams[((FlagTeamNumber == 1) ? 0:1)].AddKill(false, 1);
	`log("DVCTF > FlagCaptured" @FlagTeamNumber);
}


/*--- Gneric event ---*/
function NotifyAllPawns (byte PawnEvent, byte Param)
{
	local DVPlayerController P;
	foreach AllActors(class'DVPlayerController', P)
	{
		P_Pawn(P.Pawn).ServerNotifyFlagState(PawnEvent, Param);
	}
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	MaxScore=3
	PointsForKill=0
	PlayerControllerClass=class'PC_PlayerController'
}
