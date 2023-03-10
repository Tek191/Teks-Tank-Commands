/* 
Forces gunner to stop automatically targeting units.
Activates manual fire if deactivated.
If the gunner doesn't have a watch sector order then 
the turret is reset to the front of the hull.

PARAMETERS:
	None

RETURNS:
	None
*/

#define MANUAL_FIRE_DISABLED !isManualFire _vehicle
#define ENABLE_MANUAL_FIRE player action ["ManualFire", _vehicle]

private _vehicle = objectParent player;
private _gunner = gunner _vehicle;

if (MANUAL_FIRE_DISABLED) then {ENABLE_MANUAL_FIRE;};

_gunner disableAI "AUTOTARGET";

/*If may have Target Object/Bearing order*/
if (!TTC_gunner_hasWatchSectorOrder) then {_gunner doWatch objNull;};

player groupChat "Gunner, hold fire!";