/* 
Allows gunner to freely target and engage enemy.
Deactivates manual fire if enabled.
Cancels 'Target Object/Bearing' orders. 
Does not cancel a Watch Sector order.

PARAMETERS:
	None
	
RETURNS:
	None
*/

#define MANUAL_FIRE_ENABLED isManualFire _vehicle
#define DISABLE_MANUAL_FIRE player action ["manualFireCancel", _vehicle]

private _vehicle = objectParent player;
private _gunner = gunner _vehicle;

if (MANUAL_FIRE_ENABLED) then {DISABLE_MANUAL_FIRE;};

/*Remove cancel target action since gunner is free fire*/
TTC_gunner_hasTargetOrder = false;

_gunner enableAI "AUTOTARGET";

player groupChat "Gunner, free to engage!";