/* 
Manages the driver in calling out targets in the front sector of the vehicle.

PARAMETERS:
	None

RETURNS:
	None
*/

#define NOT_IN_VEHICLE isNull objectParent player
#define PER_FRAME_HANDLER _this select 1
#define PRIMARY_TARGET_NOT_GUNNERS_TARGET _primaryTarget isNotEqualTo TTC_orderWatchSector_currentTarget
#define PRIMARY_TARGET_NOT_DRIVERS_TARGET TTC_driver_currentTarget isNotEqualTo _primaryTarget

[{
	if (NOT_IN_VEHICLE) then {
		[PER_FRAME_HANDLER] call CBA_fnc_removePerFrameHandler;
	} 
	else {
		private _driver = driver objectParent player;
		private _vehicle = objectParent player;
		private _nearestTargets = [_driver, 150] call TTC_fnc_getNearTargets; 
		private _angle = 0;
		{ 
			_angle = (_vehicle getDir _x) - (([_vehicle] call CBA_fnc_viewDir) # 0);
			if (_angle < 0) then {
				_angle = 360 + _angle; 
			};

			if (_angle > 40 && {_angle < 320}) then {
				_nearestTargets = _nearestTargets - [_x];
			};
		} forEach _nearestTargets;

		if (_nearestTargets isNotEqualTo []) then {
			private _primaryTarget = _nearestTargets # 0;
			if (PRIMARY_TARGET_NOT_GUNNERS_TARGET && {PRIMARY_TARGET_NOT_DRIVERS_TARGET}) then {
				TTC_driver_currentTarget = _primaryTarget;
				_driver groupChat format["Target front, %1", [_primaryTarget] call TTC_fnc_getTargetType];
			};
		} 
		else {
			TTC_driver_currentTarget = -1;
		};
	};
}, 3, []] call CBA_fnc_addPerFrameHandler;