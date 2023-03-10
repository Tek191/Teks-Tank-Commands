/* 
Gets the direction the commander is looking at and translates into one of 
8 sectors, F, FL, L, RL, R(ear), RR and R(ight) in reference to the hull. Then tells the gunner to 
target the direction and updates this process until the order is cancelled.

If Autotargeting is enabled then the gunner will automatically target the most dangerous unit within 
his sector. 

PARAMETERS:
	None

RETURNS:
	None
*/	

#define TARGET_IN_LEFT_THRESHOLD [337.5, 22.5, 67.5, 112.5, 157.5, 202.5, 247.5, 292.5, 337.5] select _i <= _commanderBearing
#define TARGET_IN_RIGHT_THRESHOLD _commanderBearing < [337.5, 22.5, 67.5, 112.5, 157.5, 202.5, 247.5, 292.5, 337.5] select (_i + 1)
#define MANUAL_FIRE_DISABLED !isManualFire _vehicle
#define ENABLE_MANUAL_FIRE player action ["ManualFire", _vehicle]
#define SECTORS_AS_BEARING [337.5, 22.5, 67.5, 112.5, 157.5, 202.5, 247.5, 292.5, 337.5]
#define PER_FRAME_HANDLER _this select 1
#define HAS_TARGET TTC_gunner_orderWatchSector_currentTarget isNotEqualTo -1
#define P_GUNNER _this select 0 select 0
#define P_DRIVER _this select 0 select 1
#define LOWER_SECTOR_THRESHOLD (_this select 0 select 2) select (_this select 0 select 3)
#define P_VEHICLE _this select 0 select 4
#define P_X_OFFSET _this select 0 select 5
#define P_Y_OFFSET _this select 0 select 6

private ["_commanderBearing"];

TTC_gunner_hasWatchSectorOrder = true;
TTC_gunner_hasTargetOrder = false;
TTC_gunner_orderWatchSector_currentTarget = -1;

private _vehicle = objectParent player;

if (MANUAL_FIRE_DISABLED) then {ENABLE_MANUAL_FIRE;};

private _commanderTurretPath = _vehicle unitTurret player;
if (isTurnedOut player) then {
	_commanderBearing = [player] call TTC_fnc_getBearingRelativeToHullFromCommander;
}
else {
	_commanderBearing = ([_vehicle, _commanderTurretPath, true] call CBA_fnc_turretDir) # 0; //References hull as North
};

private _bearing = 0;
private _sectorIndex = 0;
for "_i" from 0 to 7 do {
	if (TARGET_IN_LEFT_THRESHOLD && {TARGET_IN_RIGHT_THRESHOLD}) exitWith {
		_sectorIndex = _i;
		_bearing = ((SECTORS_AS_BEARING # _i) + 22.5) mod 360;
	};
};

private _xOffset = 360 * (sin _bearing); 
private _yOffset = 360 * (cos _bearing);

player groupChat format["Gunner, watch %1.", [_sectorIndex] call TTC_fnc_getSectorName];

[{		
	if (!TTC_gunner_hasWatchSectorOrder) then {
		TTC_gunner_orderWatchSector_currentTarget = -1;
		[PER_FRAME_HANDLER] call CBA_fnc_removePerFrameHandler;
	}
	else {
		private ["_desiredDirection", "_primaryTarget", "_nearestTargets", "_targetIsAlive", "_targetIsWithinAssignedSector"];
		
		/*Gunner targets most dangerous enemy within a 45 degree cone (22.5 left/right of barrel).
		If not set to autotarget or the target has been destroyed/lost then continues to watch sector*/
		if (HAS_TARGET) then {
			TTC_gunner_orderWatchSector_delay = 2;
			_targetIsAlive = alive TTC_gunner_orderWatchSector_currentTarget;
			_targetIsWithinAssignedSector = [P_DRIVER, TTC_gunner_orderWatchSector_currentTarget, LOWER_SECTOR_THRESHOLD] call TTC_fnc_isTargetWithinAssignedSector; 
			if (_targetIsAlive && {_targetIsWithinAssignedSector}) then {
				(P_GUNNER) doWatch TTC_gunner_orderWatchSector_currentTarget;
				(P_GUNNER) doFire TTC_gunner_orderWatchSector_currentTarget;
			}
			else {
				TTC_gunner_orderWatchSector_currentTarget = -1;
				TTC_gunner_orderWatchSector_delay = 1;

				if (!_targetIsAlive) then {
					(P_GUNNER) groupChat "Target destroyed!"; 
				}; 

				if (!_targetIsWithinAssignedSector) then {
					(P_GUNNER) groupChat "Lost target!";
				}; 

				_desiredDirection = (P_VEHICLE) modelToWorld [P_X_OFFSET, P_Y_OFFSET, 0];
				(P_GUNNER) doWatch objNull;
				(P_GUNNER) doWatch _desiredDirection;				
			};
		} 
		else {
			_desiredDirection = (P_VEHICLE) modelToWorld [P_X_OFFSET, P_Y_OFFSET, 0];
			(P_GUNNER) doWatch objNull;
			(P_GUNNER) doWatch _desiredDirection;
		};

		/*Get enemies within a 45 degree cone (22.5 left/right) of barrel*/
		if ((P_GUNNER) checkAIFeature "AUTOTARGET") then {
			_nearestTargets = [P_GUNNER, 2000] call TTC_fnc_getNearTargets;
			_nearestTargets = [P_GUNNER, _nearestTargets] call TTC_fnc_getValidTargetsWithinSector;
			if (_nearestTargets isNotEqualTo []) then {
				_primaryTarget = _nearestTargets # 0;
				if (TTC_gunner_orderWatchSector_currentTarget isNotEqualTo _primaryTarget) then {
					TTC_gunner_orderWatchSector_currentTarget = _primaryTarget;
					(P_GUNNER) groupChat format["Identified target, %1", [TTC_gunner_orderWatchSector_currentTarget] call TTC_fnc_getTargetType];
				};
			} 
			else {
				TTC_gunner_orderWatchSector_currentTarget = -1;
			};
		};		
	};	
}, TTC_gunner_orderWatchSector_delay, [gunner _vehicle, driver _vehicle, SECTORS_AS_BEARING, _sectorIndex, _vehicle, _xOffset, _yOffset]] call CBA_fnc_addPerFrameHandler;