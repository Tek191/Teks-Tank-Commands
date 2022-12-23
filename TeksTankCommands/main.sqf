/* 
Author: Tek
Version 1.0.0
*/
#define IS_CREWED_BY_COMMANDER_AND_GUNNER "player isEqualTo commander objectParent player && !(isNull gunner objectParent player)"
#define IS_CREWED_BY_COMMANDER_AND_GUNNER_WITH_GUNNER_HAVING_NO_WATCH_SECTOR_ORDER "player isEqualTo commander objectParent player && !(isNull gunner objectParent player) && !TTC_hasWatchSectorOrder"
#define IS_CREWED_BY_COMMANDER_AND_GUNNER_WITH_GUNNER_HAVING_WATCH_SECTOR_ORDER "player isEqualTo commander objectParent player && !(isNull gunner objectParent player) && TTC_hasWatchSectorOrder"
#define IS_CREWED_BY_COMMANDER_AND_GUNNER_WITH_GUNNER_HAVING_AUTOTARGET_DISABLED_WITH_NO_TARGET_ORDER "player isEqualTo commander objectParent player && !((gunner objectParent player) checkAIFeature 'AUTOTARGET') && !TTC_hasTargetOrder"
#define IS_CREWED_BY_COMMANDER_AND_GUNNER_WITH_GUNNER_HAVING_AUTOTARGET_ENABLED_WITH_NO_TARGET_ORDER "player isEqualTo commander objectParent player && (gunner objectParent player) checkAIFeature 'AUTOTARGET' && !TTC_hasTargetOrder"
#define IS_CREWED_BY_COMMANDER_AND_GUNNER_WITH_GUNNER_HAVING_TARGET_ORDER "player isEqualTo commander objectParent player && !(isNull gunner objectParent player) && TTC_hasTargetOrder"
#define IS_CREWED_BY_COMMANDER_AND_GUNNER_AND_TURNED_OUT_AND_WEAPON_READY "player isEqualTo commander objectParent player && !(isNull gunner objectParent player) && isTurnedOut player && weaponState [vehicle player, vehicle player unitTurret gunner vehicle player, currentWeapon vehicle player] # 5 isEqualTo 0"


TTC_getTargetType = {
	/* 
	INPUT:
		OBJECT _unit : Unit looking at target

	RETURNS:
		STRING : Target classification

	Translates what a unit is looking at into its defined type: Infantry, Tank, Truck, Aircraft, Ship, Static,
	Object (ammobox, flag) or Logic (unit).
	*/
	params ["_unit"];
	private ["_objectType", "_category", "_type"];

	_objectType = _unit call BIS_fnc_objectType;
	_category = _objectType # 0;
	_type = _objectType # 1;

	if (_category isEqualTo "Soldier") exitWith {"Infantry"};
	if (_category isEqualTo "Logic") exitWith {"Logic Object"};
	if (_category isEqualTo "Object") exitWith {"Object"};
	if (_category isEqualTo "Vehicle") then {
		if (_type in ["Car", "Motorcycle"]) exitWith {"Truck"};
		if (_type in ["Tank", "TrackedAPC", "WheeledAPC"]) exitWith {"Tank"};
		if (_type in ["Helicopter", "Plane"]) exitWith {"Aircraft"};
		if (_type in ["Submarine", "Ship"]) exitWith {"Ship"};
		if (_type isEqualTo "StaticWeapon") exitWith {"Static"};
	}
	else {
		"Error"
	};
};


TTC_getFormattedBearing = {
	/* 
	INPUT:
		NUMBER _bearing : [0, 360]

	RETURNS:
		STRING _bearing : Formatted bearing as an integer [0, 360] in the form XXX

	Converts the given number to a string and adds the required number of 0's
	to be in the form XXX.

	For example 
	355.5 -> 355 
	  4.2 -> 004
	*/
	params ["_bearing"];

	_bearing = _bearing toFixed 0;
	
	if (count _bearing != 3) then {
		for "_i" from 1 to 3 - count _bearing do { 
			_bearing = "0" + _bearing;
		};
	};

	_bearing;
};


TTC_getRoundedDistanceToNearest100 = {
	/* 
	INPUT:
		NUMBER _distance : Positive number

	RETURNS:
		NUMBER _distance : Integer rounded to the nearest 100m

	Divides the range by a 100 and rounds to the nearest integer,
	then multiplies the range by a 100 to return to the original magnitude.
	*/
	params ["_distance"];

	_distance = (round ((_distance) / 100)) * 100;

	_distance;
};


TTC_orderTargetUnit = {
	/* 
	INPUT:
		OBJECT _commander : Unit commanding a vehicle with a gunner

	RETURNS:
		None

	Checks if a unit is looking at a unit and forces their gunner
	to target said object. 
	Will announce in group chat the target, bearing to the target and the range to the target.
	When the target is destroyed will announce so in chat.
	*/
	params ["_commander"];
	private ["_vehicle", "_gunner", "_commanderTurretPath", "_target", "_distanceToTarget", "_bearingToTarget", "_targetType", "_str", "_wasAutotargetEnabled"];

	_vehicle = vehicle _commander;
	_gunner = gunner _vehicle;
	_commanderTurretPath = _vehicle unitTurret _commander;

	_target = cursorTarget;
	if (_target isEqualTo objNull) exitWith {_gunner groupChat "No visual!"};

	_wasAutotargetEnabled = _gunner checkAIFeature "AUTOTARGET";

	TTC_hasWatchSectorOrder = false; 
	TTC_hasTargetOrder = true;

	_gunner disableAI "AUTOTARGET";
	if (!isManualFire _vehicle) then {_commander action ["ManualFire", _vehicle];};
	
	_gunner doWatch objNull;
	_gunner doFire _target;

	_distanceToTarget = [_commander distance _target] call TTC_getRoundedDistanceToNearest100;
	_bearingToTarget = ([vehicle _commander, _commanderTurretPath, false] call CBA_fnc_turretDir) # 0;
	_bearingToTarget = [_bearingToTarget] call TTC_getFormattedBearing;
	_targetType = [_target] call TTC_getTargetType;
	
	_str = format["Gunner target %1, bearing %2, range %3", _targetType, _bearingToTarget, _distanceToTarget];
	_commander groupChat _str;

	while {alive _target && TTC_hasTargetOrder} do {
		sleep 1;
	};

	/*Either target is destroyed or target order is cancelled*/
	waitUntil {sleep 0.5; !alive _target || !TTC_hasTargetOrder};
	_gunner groupChat "Target neutralized!";
	_gunner doWatch objNull;
	TTC_hasTargetOrder = false;

	if (_wasAutotargetEnabled) then { 
		if (isManualFire _vehicle) then {_commander action ["manualFireCancel", _vehicle];};
		_gunner enableAI "AUTOTARGET";
	};
};


TTC_orderSetTurretDirection = {
	/* 
	INPUT:
		OBJECT _commander : Unit commanding vehicle with a gunner

	RETURNS:
		None

	Gunner directs turret to the same bearing as the Commander is facing.
	*/	
	params ["_commander"];
	private ["_vehicle", "_gunner", "_commanderTurretPath", "_bearingToTarget", "_commanderTurretDirection", "_commanderAzimuth", 
		"_commanderElevation", "_xOffset", "_yOffset", "_desiredDirection", "_str", "_wasAutotargetEnabled"];
	
	TTC_hasWatchSectorOrder = false;
	TTC_hasTargetOrder = true;

	_vehicle = vehicle _commander;
	_gunner = gunner _vehicle;

	_wasAutotargetEnabled = _gunner checkAIFeature "AUTOTARGET"; 
	_gunner disableAI "AUTOTARGET"; 
	
	if (!isManualFire _vehicle) then {_commander action ["ManualFire", _vehicle];};
	
	_commanderTurretPath = _vehicle unitTurret _commander;
	if (isTurnedOut _commander) then {
		_bearingToTarget = ([_commander] call CBA_fnc_viewDir) # 0;
		_commanderTurretDirection = [_commander] call CBA_fnc_viewDir;
		_commanderTurretDirection set [0, [_commander] call TTC_getBearingRelativeToHullFromCommander];
	} 
	else {
		_bearingToTarget = ([_vehicle, _commanderTurretPath, false] call CBA_fnc_turretDir) # 0;
		_commanderTurretDirection = [_vehicle, _commanderTurretPath, true] call CBA_fnc_turretDir; //[Azimuth [0, 360], Elevation [-90, 90]]
	};
	_bearingToTarget = [_bearingToTarget] call TTC_getFormattedBearing;

	_commanderAzimuth = _commanderTurretDirection # 0;
	_commanderElevation = _commanderTurretDirection # 1;
	_xOffset = 360 * (sin _commanderAzimuth); 
	_yOffset = 360 * (cos _commanderAzimuth); 
	_desiredDirection = _vehicle modelToWorld [_xOffset, _yOffset, _commanderElevation];

	_gunner doWatch objNull;
	_gunner doWatch _desiredDirection;

	_str = format["Gunner watch bearing %1.", _bearingToTarget];
	_commander groupChat _str;

	waitUntil {sleep 0.5; !TTC_hasTargetOrder}; 

	if (_wasAutotargetEnabled) then {
		if (isManualFire _vehicle) then {_commander action ["manualFireCancel", _vehicle];};
		_gunner enableAI "AUTOTARGET";
	};
};


TTC_orderWatchSector = {
	/* 
	INPUT:
		OBJECT _commander : Unit commanding vehicle with a gunner

	RETURNS:
		None

	Gets the direction the commander is looking at and translates into one of 
	8 sectors, F, FL, L, RL, R(ear), RR and R(ight) in reference to the hull. Then tells the gunner to 
	target the direction and updates this process until the order is cancelled.

	If Autotargeting is enabled then the gunner will automatically target the most dangerous unit within 
	his sector. 
	*/	
	params ["_commander"];
	private ["_vehicle", "_gunner", "_commanderTurretPath", "_commanderBearing", "_bearing", "_sectorBearing", "_sectorIndex", "_direction", 
		"_xOffset", "_yOffset", "_desiredDirection", "_str", "_primaryTarget", "_nearestTargets", "_driver", "_lastTarget", "_targetIsAlive",
		"_targetIsWithinAssignedSector", "_delay"];

	TTC_hasWatchSectorOrder = true;
	TTC_hasTargetOrder = false;

	_vehicle = vehicle _commander;
	_gunner = gunner _vehicle;
	_driver = driver _vehicle;

	if (!isManualFire _vehicle) then {_commander action ["ManualFire", _vehicle];};
	
	_commanderTurretPath = _vehicle unitTurret _commander;
	if (isTurnedOut _commander) then {
		_commanderBearing = [_commander] call TTC_getBearingRelativeToHullFromCommander;
	}
	else {
		_commanderBearing = ([_vehicle, _commanderTurretPath, true] call CBA_fnc_turretDir) # 0; //References hull as North
	};
	
	_bearing = 0;
	_sectorBearing = [337.5, 22.5, 67.5, 112.5, 157.5, 202.5, 247.5, 292.5, 337.5];
	_sectorIndex = 0;
	for "_i" from 0 to 7 do {
		if (_sectorBearing # _i <= _commanderBearing && _commanderBearing < _sectorBearing # (_i + 1)) exitWith {
			_sectorIndex = _i;
			_bearing = ((_sectorBearing # _i) + 22.5) mod 360;
		};
	};

	_direction = [_sectorIndex] call TTC_getSectorName;

	_xOffset = 360 * (sin _bearing); 
	_yOffset = 360 * (cos _bearing);
	
	_str = format["Gunner watch %1.", _direction];
	_commander groupChat _str;

	_lastTarget = -1; 
	_delay = 1;
	while {TTC_hasWatchSectorOrder} do {
		/*Gunner automatically targets enemies within a 45 degree cone (22.5 left/right of barrel) 
		  */
		if (_gunner checkAIFeature "AUTOTARGET") then {
			_nearestTargets = [_gunner, 2000] call TTC_getNearTargets;
			_nearestTargets = [_gunner, _nearestTargets] call TTC_getValidTargetsWithinSector;
			if (count _nearestTargets isNotEqualTo 0) then {
				_primaryTarget = _nearestTargets # 0;
				if (_lastTarget isNotEqualTo _primaryTarget) then {
					_lastTarget = _primaryTarget;
					_gunner groupChat format["Identified target, %1", [_primaryTarget] call TTC_getTargetType];
				};
			};
		};

		/*Gunner targets most dangerous enemy within a 45 degree cone (22.5 left/right of barrel).
		  If not set to autotarget or the target has been destroyed/lost then continues to watch sector*/
		if (_lastTarget isNotEqualTo -1) then {
			_delay = 2; 
			_targetIsAlive = alive _lastTarget;
			_targetIsWithinAssignedSector = [_driver, _lastTarget, _sectorBearing # _sectorIndex] call TTC_isTargetWithinAssignedSector; 
			if (_targetIsAlive && _targetIsWithinAssignedSector) then {
				_gunner doWatch _lastTarget;
				_gunner doFire _lastTarget;
			}
			else {
				_lastTarget = -1;
				_delay = 1; 

				if (!_targetIsAlive) then {
					_gunner groupChat "Target destroyed."; 
					}; 

				if (!_targetIsWithinAssignedSector) then {
					_gunner groupChat "Lost target.";
					}; 

				_desiredDirection = _vehicle modelToWorld [_xOffset, _yOffset, 0];
				_gunner doWatch objNull;
				_gunner doWatch _desiredDirection;				
			};
		} 
		else {
			_desiredDirection = _vehicle modelToWorld [_xOffset, _yOffset, 0];
			_gunner doWatch objNull;
			_gunner doWatch _desiredDirection;
		};

		/*Required at minimum 1 seconds to prevent gunner
		  from swinging turret from side to side on Autotarget.
		  2 seconds for when the gunner has target.*/
		sleep _delay; 
	};
};


TTC_getSectorName = {
	/* 
	INPUT:
		NUMBER _sectorIndex : [0, 7]

	RETURNS:
		STRING _sectorName 

	360 degrees are split into 8 sectors in clockwise fashion.
	Translates the sector number into its name.
	*/	
	params ["_sectorIndex"];
	private ["_sectorName"];
	
	switch (_sectorIndex) do {
		case 0: {_sectorName = "Front"};
		case 1: {_sectorName = "Front Right"};
		case 2: {_sectorName = "Right"};
		case 3: {_sectorName = "Rear Right"};
		case 4: {_sectorName = "Rear"};
		case 5: {_sectorName = "Rear Left"};
		case 6: {_sectorName = "Left"};
		case 7: {_sectorName = "Front Left"};
		default {_sectorName = "ERROR"};
	};	

	_sectorName;
};


TTC_isTargetWithinAssignedSector = {
	/* 
	INPUT:
		OBJECT _driver : Driver of caller vehicle
		OBJECT _target 
		NUMBER _sectorLowerThreshold : [337.5, 22.5, 67.5, 112.5, 157.5, 202.5, 247.5, 292.5, 337.5]

	RETURNS:
		BOOLEAN _return

	Gets bearing of target relative to the hull of the vehicle.
	Checks if the bearing is within the given sector.
	*/	
	params ["_driver", "_target", "_sectorLowerThreshold"];
	private ["_return", "_hullBearing", "_targetToUnitBearing", "_hullToTargetBearing"];

	_hullBearing = ([_driver] call CBA_fnc_viewDir) # 0; 
	_targetToUnitBearing = _driver getDir _target; 
	_hullToTargetBearing = _targetToUnitBearing - _hullBearing; 

	/*Ensure bearing is positive*/
	if (_hullToTargetBearing < 0) then { 
		_hullToTargetBearing = 360 + _hullToTargetBearing;
	};

	if (_sectorLowerThreshold isEqualTo 337.5) then {
		/*'North' is 337.5 < x < 22.5, hence an exception by using || instead of &&*/
		if (_sectorLowerThreshold  <= _hullToTargetBearing || _hullToTargetBearing < (_sectorLowerThreshold + 45) mod 360) then {
			_return = true;
		} else {
			_return = false;
		};
	} 
	else {
		if (_sectorLowerThreshold  <= _hullToTargetBearing && _hullToTargetBearing < (_sectorLowerThreshold + 45) mod 360) then {
			_return = true;
		} else {
			_return = false;
		};
	};

	_return;
};


TTC_isTargetWithinGunnersVisionCone = {
	/* 
	INPUT:
		OBJECT _gunner : Unit to check target against
		OBJECT _target : Target to check Unit against

	RETURNS:
		BOOLEAN 

	Gets the relative to North bearing to the target and checks if the angle to the target 
	is within a 45 degree cone (22.5 left/right)

	{(_angleToTarget + 22.5) mod 360 < 22.5} is used for reflex angles [337.5, 360) -> [0, 22.5)
	*/ 
	params ["_gunner", "_target"];
	private ["_angleToTarget"]; 

	_angleToTarget = [_gunner, _target] call TTC_getAngleBetweenUnitAndTarget;

	if ((_angleToTarget + 22.5) mod 360 < 22.5 || _angleToTarget < 22.5) exitWith {true;};
	false;
};


TTC_getNearTargets = {
	/* 
	INPUT:
		OBJECT _unit : Unit requesting near targets

	RETURNS:
		ARRAY<OBJECT> _nearEnemyTargets : Enemies near caller filtered by hostile sides to caller

	Gets the nearest targets to unit and filters them to exclude non-enemies and non-units/vehicles.
	First enemy is considered most dangerous to the unit calling (return format of nearTargets).
	*/
	params ["_unit", "_distance"];
	private ["_nearTargets", "_nearEnemyTargets", "_side", "_object"];

	_nearTargets = _unit nearTargets _distance;
	_nearEnemyTargets = [];

	{
		_side = _x # 2;
		if (!(_side in TTC_enemySides)) then {continue;};

		_object = _x # 4;
		_nearEnemyTargets append [_object];
	} forEach _nearTargets;

	_nearEnemyTargets;
};


TTC_getValidTargetsWithinSector = {
	/* 
	INPUT:
		OBJECT _gunner : Unit requesting target check
		ARRAY<OBJECT> _targets : Targets near Unit 

	RETURNS:
		ARRAY<OBJECT> _targets : Targets near Unit - excluding those not within 45 degree cone from unit
	*/
	params ["_gunner", "_targets"];

	{
		if ([_gunner, _x] call TTC_isTargetWithinGunnersVisionCone) then {continue;};
		_targets = _targets - [_x];
	} forEach _targets;

	_targets;
};


TTC_getEnemySides = {
	/* 
	INPUT:
		OBJECT _unit : Unit to compare against

	RETURNS:
		ARRAY<SIDES> _enemySides
	*/
	params ["_unit"];
	private ["_unitSide", "_enemySides"];

	_unitSide = side _unit;
	_enemySides = [blufor, opfor, independent, civilian] - [_unitSide];

	{
		if ([_unitSide, _x] call BIS_fnc_sideIsFriendly) then {_enemySides = _enemySides - [_x];};
	} forEach _enemySides;

	_enemySides;
};


TTC_cancelGunnerTarget = {
	/* 
	INPUT:
		OBJECT _commander : Unit commanding a gunner

	RETURNS:
		None

	Forces gunner to stop watching / targeting an object
	*/
	params ["_commander"];
	private ["_vehicle", "_gunner"];
	
	_vehicle = vehicle _commander;
	_gunner = gunner _vehicle;

	_gunner doWatch objNull;
	_commander groupChat "Gunner cancel target!";

	TTC_hasTargetOrder = false;
};


TTC_enableGunnerAutoTargeting = {
	/* 
	INPUT:
		OBJECT _commander : Unit commanding a gunner

	RETURNS:
		None

	Allows gunner to freely target and engage enemy.
	Deactivates manual fire if enabled.
	Cancels 'Target Object/Bearing' orders. 
	Does not cancel a Watch Sector order.
	*/
	params ["_commander"];
	private ["_vehicle", "_gunner"];

	_vehicle = vehicle _commander;
	_gunner = gunner _vehicle;

	if (isManualFire _vehicle) then {_commander action ["manualFireCancel", _vehicle];};

	/*Remove cancel target action since gunner is free fire*/
	TTC_hasTargetOrder = false;

	_gunner enableAI "AUTOTARGET";

	_commander groupChat "Gunner free to target!";
};


TTC_disableGunnerAutoTargeting = {
	/* 
	INPUT:
		OBJECT _commander : Unit commanding a gunner

	RETURNS:
		None

	Forces gunner to stop automatically targeting units.
	Activates manual fire if deactivated.
	If the gunner doesn't have a watch sector order then 
	the turret is reset to the front of the hull.
	*/
	params ["_commander"];
	private ["_vehicle", "_gunner"];

	_vehicle = vehicle _commander;
	_gunner = gunner _vehicle;
	
	if (!isManualFire _vehicle) then {_commander action ["ManualFire", _vehicle];};
	
	_gunner disableAI "AUTOTARGET";

	/*If may have Target Object/Bearing order*/
	if (!TTC_hasWatchSectorOrder) then {_gunner doWatch objNull;};
	
	_commander groupChat "Gunner await target!";
};


TTC_stopWatchingSector = {
	/* 
	INPUT:
		OBJECT _commander : Unit commanding a gunner

	RETURNS:
		None

	Forces gunner to stop watching sector
	*/
	params ["_commander"];
	private ["_vehicle", "_gunner"];

	_vehicle = vehicle _commander;
	_gunner = gunner _vehicle;

	_gunner doWatch objNull;
	_commander groupChat "Gunner sticky front!";

	TTC_hasWatchSectorOrder = false;
};


TTC_setGunnerAccuracy = {
	params ["_commander"];
	private ["_vehicle", "_gunner"];
	
	_vehicle = vehicle _commander;
	_gunner = gunner _vehicle;

	{_gunner setSkill [_x, 1]} forEach ["aimingAccuracy", "aimingSpeed", "aimingShake"];
};


TTC_getBearingRelativeToHullFromCommander = {
	/* 
	INPUT:
		OBJECT _commander : Unit requesting bearing

	RETURNS:
		NUMBER _bearing : bearing relative to Hull

	Gets the bearing between the hull and Commander's vision relative to North.
	The calculated bearing is where the player is looking with reference to the hull instead 
	of North.

	Example 
	Hull = 90 [Relative to North]
	Player = 130 [Relative to North]
	Bearing = 40 [Relative to the Hull]

	Example Overflow
	Hull = 90 [Relative to North]
	Player = 50 [Relative to North]
	Bearing = -40 [Relative to the Hull]
	Actual Bearing is 360 + (-40) = 320 [Relative to Hull]
	*/
	params ["_commander"];
	private ["_vehicle", "_driver", "_bearing", "_hullBearing", "_commanderBearing"];

	_vehicle = vehicle _commander;
	_driver = driver _vehicle;

	_hullBearing = ([_driver] call CBA_fnc_viewDir) # 0;
	_commanderBearing = ([_commander] call CBA_fnc_viewDir) # 0;
	
	_bearing = _commanderBearing - _hullBearing;

	if (_bearing < 0) then {
		_bearing = 360 + _bearing;
	};

	_bearing;
};


TTC_getAngleBetweenUnitAndTarget = {
	/* 
	INPUT:
		OBJECT _unit : Unit requesting angle to target
		OBJECT _target : Target angle is requested to

	RETURNS:
		NUMBER _angle : _angle between target and unit

	Gets the angle between the unit's bearing and the relative bearing of the target
	to the unit.

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
	private ["_unitBearing", "_targetToUnitBearing", "_angle"];

	_unitBearing = getDir _unit;
	_targetToUnitBearing = _unit getDir _target;

	/*Ensure angle is positive*/
	if (_unitBearing > _targetToUnitBearing) then {
		_angle = _unitBearing - _targetToUnitBearing;
	} else {
		_angle = _targetToUnitBearing - _unitBearing;
	};
			
	_angle;
};


TTC_forceFire = {
	/* 
	INPUT:
		OBJECT _commander : Commander requesting gunner to fire

	RETURNS:
		None

	Gets the first available firemode for the currently selected weapon 
	and forces the gunner to fire. For automatic weapons it greatly depends
	on the first fire mode. It may be single fire.
	*/
	params ["_commander"];
	private ["_vehicle", "_gunner", "_fireModes"];
	
	_vehicle = vehicle _commander;
	_gunner = gunner _vehicle;
	_fireModes = getArray (configFile >> "CfgWeapons" >> currentWeapon vehicle player >> "modes");

	_gunner forceWeaponFire [currentWeapon _vehicle, _fireModes # 0];
};


TTC_addActionsToPlayer = {
	player addAction
	["Fire",	
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; 
		[_caller] call TTC_forceFire;
	}, nil, 999, true, false, "", IS_CREWED_BY_COMMANDER_AND_GUNNER_AND_TURNED_OUT_AND_WEAPON_READY, -1, false, "", ""];

	player addAction
	["Target Object",	
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; 
		[_caller] call TTC_orderTargetUnit;
	}, nil, 999, true, false, "", IS_CREWED_BY_COMMANDER_AND_GUNNER, -1, false, "", ""];

	player addAction
	["Target Bearing",	
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; 
		[_caller] call TTC_orderSetTurretDirection;
	}, nil, 999, true, false, "", IS_CREWED_BY_COMMANDER_AND_GUNNER, -1, false, "", ""];

	player addAction
	["Cancel Target",	
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; 
		[_caller] call TTC_cancelGunnerTarget;
	}, nil, 999, true, false, "", IS_CREWED_BY_COMMANDER_AND_GUNNER_WITH_GUNNER_HAVING_TARGET_ORDER, -1, false, "", ""];

	player addAction
	["Watch Sector",	
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; 
		[_caller] call TTC_orderWatchSector;
	}, nil, 999, true, false, "", IS_CREWED_BY_COMMANDER_AND_GUNNER_WITH_GUNNER_HAVING_NO_WATCH_SECTOR_ORDER, -1, false, "", ""];

	player addAction
	["Stop Watching Sector",	
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; 
		[_caller] call TTC_stopWatchingSector;
	}, nil, 999, true, false, "", IS_CREWED_BY_COMMANDER_AND_GUNNER_WITH_GUNNER_HAVING_WATCH_SECTOR_ORDER, -1, false, "", ""];

	player addAction
	["Enable Autotargeting",	
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; 
		[_caller] call TTC_enableGunnerAutoTargeting;
	}, nil, 999, true, false, "", IS_CREWED_BY_COMMANDER_AND_GUNNER_WITH_GUNNER_HAVING_AUTOTARGET_DISABLED_WITH_NO_TARGET_ORDER, -1, false, "", ""];

	player addAction
	["Disable Autotargeting",	
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; 
		[_caller] call TTC_disableGunnerAutoTargeting;
	}, nil, 999, true, false, "", IS_CREWED_BY_COMMANDER_AND_GUNNER_WITH_GUNNER_HAVING_AUTOTARGET_ENABLED_WITH_NO_TARGET_ORDER, -1, false, "", ""];
};


TTC_main = {
	/*Used as flag to cancel order and to update addActions*/
	TTC_hasWatchSectorOrder = false;
	TTC_hasTargetOrder = false;

	/*Used for identifying units*/
	TTC_enemySides = [player] call TTC_getEnemySides;
	
	/*Used for targetting ('doFire') in 'TTC_orderTargetUnit'*/
	{player reveal _x} forEach allUnits + vehicles;
	
	/*Used to allow CMD to have full control over gunner in
	  targeting an object, unit or bearing. If gunner is in contact
	  he will disengage to a different target / bearing if told to.*/
	[player] call TTC_disableGunnerAutoTargeting;
	
	[player] call TTC_setGunnerAccuracy;

	[] call TTC_addActionsToPlayer;
};

[] call TTC_main;