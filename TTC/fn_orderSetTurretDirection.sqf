/* 
Gunner directs turret to the same bearing as the Commander is facing.

INPUT:
	OBJECT _commander : Unit commanding vehicle with a gunner

RETURNS:
	None
*/	

#define MANUAL_FIRE_DISABLED !isManualFire _vehicle
#define ENABLE_MANUAL_FIRE _commander action ["ManualFire", _vehicle]
#define X_OFFSET 360 * (sin _commanderAzimuth)
#define Y_OFFSET 360 * (cos _commanderAzimuth)
#define P_WAS_AUTOTARGET_ENABLED _this select 0
#define P_VEHICLE _this select 1
#define P_COMMANDER _this select 2
#define P_GUNNER _this select 3

params ["_commander"];
private ["_bearingToTarget", "_commanderTurretDirection"];

TTC_gunner_hasWatchSectorOrder = false;
TTC_gunner_hasTargetOrder = true;

private _vehicle = objectParent _commander;
private _gunner = gunner _vehicle;

private  _wasAutotargetEnabled = _gunner checkAIFeature "AUTOTARGET"; 
_gunner disableAI "AUTOTARGET"; 

if (MANUAL_FIRE_DISABLED) then {ENABLE_MANUAL_FIRE;};

private _commanderTurretPath = _vehicle unitTurret _commander;
if (isTurnedOut _commander) then {
	_bearingToTarget = ([_commander] call CBA_fnc_viewDir) # 0;
	_commanderTurretDirection = [_commander] call CBA_fnc_viewDir;
	_commanderTurretDirection set [0, [_commander] call TTC_fnc_getBearingRelativeToHullFromCommander];
} 
else {
	_bearingToTarget = ([_vehicle, _commanderTurretPath, false] call CBA_fnc_turretDir) # 0;
	_commanderTurretDirection = [_vehicle, _commanderTurretPath, true] call CBA_fnc_turretDir; //[Azimuth [0, 360], Elevation [-90, 90]]
};
_bearingToTarget = [_bearingToTarget] call TTC_fnc_getFormattedBearing;

private _commanderAzimuth = _commanderTurretDirection # 0;
private _commanderElevation = _commanderTurretDirection # 1;
private _desiredDirection = _vehicle modelToWorld [X_OFFSET, Y_OFFSET, _commanderElevation];

_gunner doWatch objNull;
_gunner doWatch _desiredDirection;

_commander groupChat format["Gunner, target %1.", _bearingToTarget];

[{!TTC_gunner_hasTargetOrder}, {
	if (P_WAS_AUTOTARGET_ENABLED) then {
		if (isManualFire (P_VEHICLE)) then {(P_COMMANDER) action ["manualFireCancel", P_VEHICLE];};
		(P_GUNNER) enableAI "AUTOTARGET";
	};
}, [_wasAutotargetEnabled, _vehicle, _commander, _gunner]] call CBA_fnc_waitUntilAndExecute;