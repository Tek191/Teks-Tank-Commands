/* 
Orders gunner to stop watching target

PARAMETERS:
	None

RETURNS:
	None
*/

private _vehicle = objectParent player;
private _gunner = gunner _vehicle;

_gunner doWatch objNull;
player groupChat "Gunner, cancel target";

TTC_gunner_hasTargetOrder = false;