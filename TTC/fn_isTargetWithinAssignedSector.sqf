/* 
Gets bearing of target relative to the hull of the vehicle.
Checks if the bearing is within the given sector.

PARAMETERS:
	OBJECT _driver : Driver of caller vehicle
	OBJECT _target 
	NUMBER _sectorLowerThreshold : [337.5, 22.5, 67.5, 112.5, 157.5, 202.5, 247.5, 292.5, 337.5]

RETURNS:
	BOOLEAN _return
*/	

#define TARGET_IN_LEFT_THRESHOLD _sectorLowerThreshold  <= _hullToTargetBearing
#define TARGET_IN_RIGHT_THRESHOLD _hullToTargetBearing < (_sectorLowerThreshold + 45) mod 360

params ["_driver", "_target", "_sectorLowerThreshold"];
private ["_return"];

private _hullBearing = ([_driver] call CBA_fnc_viewDir) # 0; 
private _targetToUnitBearing = _driver getDir _target; 
private _hullToTargetBearing = _targetToUnitBearing - _hullBearing; 

/*Ensure bearing is positive*/
if (_hullToTargetBearing < 0) then { 
	_hullToTargetBearing = 360 + _hullToTargetBearing;
};

if (_sectorLowerThreshold isEqualTo 337.5) then {
	/*'North' is 337.5 < x < 22.5, hence an exception by using || instead of &&*/
	if (TARGET_IN_LEFT_THRESHOLD || {TARGET_IN_RIGHT_THRESHOLD}) then {
		_return = true;
	} else {
		_return = false;
	};
} 
else {
	if (TARGET_IN_LEFT_THRESHOLD && {TARGET_IN_RIGHT_THRESHOLD}) then {
		_return = true;
	} else {
		_return = false;
	};
};

_return;