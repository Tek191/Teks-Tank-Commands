/* 
Gets the angle between the unit's bearing and the relative bearing of the target
to the unit.

PARAMETERS:
	OBJECT _unit : Unit requesting angle to target
	OBJECT _target : Target angle is requested to

RETURNS:
	NUMBER _angle : _angle between target and unit

Example 
Unit = 20 [Relative to North]
Target = 45 [Relative to Unit]
Angle = 25 [Relative to Unit]

Example
Unit = 45 [Relative to North]
Target = 20 [Relative to Unit]
Angle = 25 [Relative to Unit]
*/

params ["_unit", "_target"];
private ["_angle"];

private _unitBearing = getDir _unit;
private _targetToUnitBearing = _unit getDir _target;

/*Ensure angle is positive*/
if (_unitBearing > _targetToUnitBearing) then {
	_angle = _unitBearing - _targetToUnitBearing;
} else {
	_angle = _targetToUnitBearing - _unitBearing;
};
		
_angle;