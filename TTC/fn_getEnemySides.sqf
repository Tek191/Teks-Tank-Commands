/* 
Gets an array of all sides considered hostile to the unit

PARAMETERS:
	OBJECT _unit : Unit to compare against

RETURNS:
	ARRAY<SIDES> _enemySides
*/

params ["_unit"];

private _unitSide = side _unit;
private _enemySides = [blufor, opfor, independent, civilian] - [_unitSide];

{
	if ([_unitSide, _x] call BIS_fnc_sideIsFriendly) then {_enemySides = _enemySides - [_x];};
} forEach _enemySides;

_enemySides;