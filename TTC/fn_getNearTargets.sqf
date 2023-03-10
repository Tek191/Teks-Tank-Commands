/* 
Gets the nearest targets to unit and filters them to exclude non-enemies and non-units/vehicles.
First enemy is considered most dangerous to the unit calling (return format of nearTargets).

PARAMETERS:
	OBJECT _unit : Unit requesting near targets

RETURNS:
	ARRAY<OBJECT> _nearEnemyTargets : Enemies near caller filtered by hostile sides to caller
*/

#define UNIT_IS_FRIENDLY !(_side in TTC_enemySides)

params ["_unit", "_distance"];
private ["_side", "_object"];

private _nearTargets = _unit nearTargets _distance;
private _nearEnemyTargets = [];

{
	_side = _x # 2;
	if (UNIT_IS_FRIENDLY) then {continue;};

	_object = _x # 4;
	_nearEnemyTargets append [_object];
} forEach _nearTargets;

_nearEnemyTargets;