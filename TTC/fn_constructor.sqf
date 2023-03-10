#define IN_VEHICLE !(isNull objectParent player)

/* 
Intializes global variables and vehicle state upon mounting a vehicle.
*/
player addEventHandler ["GetInMan", {
	params ["_unit", "_role", "_vehicle", "_turret"];
	call TTC_fnc_main;
}];

/* 
Adds all orders in action menu and keybinds to manage driver.
All added interactions require player to be in a vehicle.
*/
call TTC_fnc_addActionsToPlayer;
call TTC_fnc_addKeyBindsToPlayer;

call TTC_fnc_briefing;

/*Used for targetting ('doFire') in 'TTC_fnc_orderTargetUnit'*/
{player reveal _x} forEach allUnits + vehicles;

/*Used for identifying units*/
TTC_enemySides = [player] call TTC_fnc_getEnemySides;