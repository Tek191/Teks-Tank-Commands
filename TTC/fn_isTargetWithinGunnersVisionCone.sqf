/* 
Gets the relative to North bearing to the target and checks if the angle to the target 
is within a 45 degree cone (22.5 left/right)

{(_angleToTarget + 22.5) mod 360 < 22.5} is used for reflex angles [337.5, 360) -> [0, 22.5)

PARAMETERS:
	OBJECT _gunner : Unit to check target against
	OBJECT _target : Target to check Unit against

RETURNS:
	BOOLEAN 
*/ 

params ["_gunner", "_target"];

private _angleToTarget = [_gunner, _target] call TTC_fnc_getAngleBetweenUnitAndTarget;

if ((_angleToTarget + 22.5) mod 360 < 22.5 || {_angleToTarget < 22.5}) exitWith {true;};
false;