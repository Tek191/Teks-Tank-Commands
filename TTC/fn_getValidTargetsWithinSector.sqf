/* 
PARAMETERS:
	OBJECT _gunner : Unit requesting target check
	ARRAY<OBJECT> _targets : Targets near Unit 

RETURNS:
	ARRAY<OBJECT> _targets : Targets near Unit - excluding those not within 45 degree cone from unit
*/
params ["_gunner", "_targets"];

{
	if ([_gunner, _x] call TTC_fnc_isTargetWithinGunnersVisionCone) then {continue;};
	_targets = _targets - [_x];
} forEach _targets;

_targets;