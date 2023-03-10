/* 
Checks if a unit is looking at a unit and forces their gunner
to target said object. 
Will announce in group chat the target, bearing to the target and the range to the target.
When the target is destroyed will announce so in chat.

PARAMETERS:
	None

RETURNS:
	None
*/

#define CMD_TURRET_PATH _vehicle unitTurret player
#define NO_TARGET _target isEqualTo objNull
#define ENABLE_MANUAL_FIRE player action ["ManualFire", _vehicle]
#define P_TARGET _this select 0
#define P_GUNNER _this select 1
#define P_WAS_AUTO_TARGET_ENABLED _this select 2
#define P_VEHICLE _this select 3
#define MANUAL_FIRE_DISABLED !isManualFire (_this select 3)
#define P_COMMANDER _this select 4
#define TARGET_DEAD !alive (_this select 0)

private _vehicle = objectParent player;
private _gunner = gunner _vehicle;

private _target = cursorTarget;
if (NO_TARGET) exitWith {_gunner groupChat "No visual on target!"};

private _wasAutotargetEnabled = _gunner checkAIFeature "AUTOTARGET";

TTC_gunner_hasWatchSectorOrder = false; 
TTC_gunner_hasTargetOrder = true;

_gunner disableAI "AUTOTARGET";
if (!isManualFire _vehicle) then {ENABLE_MANUAL_FIRE;};

_gunner doWatch objNull;
_gunner doFire _target;

private _distanceToTarget = [player distance _target] call TTC_fnc_getRoundedDistanceToNearest100;
private _bearingToTarget = ([_vehicle, CMD_TURRET_PATH, false] call CBA_fnc_turretDir) # 0; 
_bearingToTarget = [_bearingToTarget] call TTC_fnc_getFormattedBearing;
private _targetType = [_target] call TTC_fnc_getTargetType;

player groupChat format["Gunner, target %1, bearing %2, range %3", _targetType, _bearingToTarget, _distanceToTarget];

[{!TTC_gunner_hasTargetOrder || {TARGET_DEAD}}, {
	if (TARGET_DEAD) then {
		(P_GUNNER) groupChat "Target neutralized!";
	};

	(P_GUNNER) doWatch objNull;
	TTC_gunner_hasTargetOrder = false;

	if (P_WAS_AUTO_TARGET_ENABLED) then { 
		if (MANUAL_FIRE_DISABLED) then {
			(P_COMMANDER) action ["manualFireCancel", P_VEHICLE];
		};
		(P_GUNNER) enableAI "AUTOTARGET";
	};
}, [_target, _gunner, _wasAutotargetEnabled, _vehicle, player]] call CBA_fnc_waitUntilAndExecute;