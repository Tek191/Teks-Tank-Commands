/* 
Manages the default value of global variables and the state of player's AI.

PARAMETERS:
	None

RETURNS:
	None
*/

/*
AI GUNNER

TTC_gunner_hasWatchSectorOrder BOOLEAN
Used as flag to cancel order and to update addActions

TTC_gunner_hasTargetOrder BOOLEAN
Used as flag to cancel order and to update addActions

TTC_gunner_orderWatchSector_currentTarget OBJECT / NUMBER
Used for referencing target in Watch Sector. Global to handle function->eventhandler scope
If no enemy present then -1.

TTC_gunner_orderWatchSector_delay NUMBER
Used to delay gathering of new targets for gunner. Global to handle function->eventhandler scope
*/
TTC_gunner_hasWatchSectorOrder = false;
TTC_gunner_hasTargetOrder = false;
TTC_gunner_orderWatchSector_currentTarget = -1;
TTC_gunner_orderWatchSector_delay = 1;

/*
AI DRIVER

TTC_driver_movementState NUMBER
0 = Stationary, 1 = Forward, -1 = Backward
Used to determine the condition of the vehicle's movement, vehicle can advance, reverse or halt/remain stationary

TTC_driver_speedMode STRING
("SLOW", "FORWARD", "FAST")
Used when vehicle is not configured for speed limiter to determine vehicle speed

TTC_driver_speeds ARRAY<NUMBER>
[7 elements] where _x is a number
Used to determine applicable speed limit to achieve 10/20/30/40/50/60/unrestricted speed limit

TTC_driver_speedModes ARRAY<STRING>
[7 elements] where _x is a speedMode ("SLOW", "FORWARD", "FAST")
Used to determine applicable speed mode to achieve 10/20/30/40/50/60/unrestricted speed limit

TTC_driver_speedIndex NUMBER 
[0, 6] where _x in TTC_driver_speeds -> 0:10kmh, 1:20kmh ... 6:Unlimited.

TTC_driver_isConfiguredVehicle BOOLEAN
Used to determine whether vehicle has preset speeds and speed modes for the speed limiter.

TTC_driver_currentTarget OBJECT / NUMBER
If no enemy present then -1.
Used to determine if driver has called out the most dangerous threat in his security sector.
*/
TTC_driver_movementState = 0; 
TTC_driver_speedMode = "FORWARD"; 
TTC_driver_speeds = [];
TTC_driver_speedModes = [];
TTC_driver_speedIndex = 6; 
TTC_driver_isConfiguredVehicle = call TTC_fnc_isVehicleConfigured;
TTC_driver_currentTarget = -1;
if (TTC_driver_isConfiguredVehicle) then {
	TTC_driver_speeds = call TTC_fnc_getSpeedConfiguration;
	TTC_driver_speedModes = call TTC_fnc_getSpeedModeConfiguration;
};

/*
Used to allow CMD to have full control over gunner in targeting an object, unit or bearing. 
If gunner is in contact he will disengage to a different target / bearing if told to.
*/
call TTC_fnc_disableGunnerAutoTargeting;

/*
Used to decrease gunner errors in acquiring target - may require testing with lower values
*/
call TTC_fnc_setGunnerAccuracy;

/* 
Used to manage driver calling targets out and for driver to react to move and speed limiter orders.
*/
call TTC_fnc_addDriverMoveOrderHandler;
call TTC_fnc_addDriverVision;