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
function FlagTaken(byte FlagTeamNumber)
{
	local DVPlayerController P;
	foreach AllActors(class'DVPlayerController', P)
	{
		P.ServerNotifyFlagState(0, FlagTeamNumber);
	}
	`log("DVCTF > FlagTaken");
}


/*--- The flag was dropped ---*/
function FlagDropped(byte FlagTeamNumber)
{
	local DVPlayerController P;
	foreach AllActors(class'DVPlayerController', P)
	{
		P.ServerNotifyFlagState(1, FlagTeamNumber);
	}
	`log("DVCTF > FlagDropped");
}


/*--- The flag was returned ---*/
function FlagReturned(byte FlagTeamNumber)
{
	local DVPlayerController P;
	foreach AllActors(class'DVPlayerController', P)
	{
		P.ServerNotifyFlagState(2, FlagTeamNumber);
	}
	`log("DVCTF > FlagReturned");
}


/*--- The flag was captured ---*/
function FlagCaptured(byte FlagTeamNumber)
{
	local DVPlayerController P;
	foreach AllActors(class'DVPlayerController', P)
	{
		P.ServerNotifyFlagState(2, FlagTeamNumber);
	}
	Teams[((FlagTeamNumber == 1) ? 0:1)].AddKill(false, 1);
	`log("DVCTF > FlagCaptured");
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	MaxScore=3
	PointsForKill=0
}
