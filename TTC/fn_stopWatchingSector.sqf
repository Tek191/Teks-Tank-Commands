/* 
Forces gunner to stop watching sector

PARAMETERS:
	None

RETURNS:
	None
*/

private _vehicle = objectParent player;
private _gunner = gunner _vehicle;

_gunner doWatch objNull;
player groupChat "Gunner, sticky front!";

TTC_gunner_hasWatchSectorOrder = false;