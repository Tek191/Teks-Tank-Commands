/* 
Manages the driver in moving forward/backward or halting.
If the vehicle is not configured then the built in speed modes are used,
else the vehicle uses the 7 speed limits.

PARAMETERS:
	None

RETURNS:
	None
*/

#define IS_CMD_AND_HAS_DRIVER player isEqualTo commander objectParent player && {!(isNull driver objectParent player)}
#define NOT_IN_VEHICLE isNull objectParent player
#define PER_FRAME_HANDLER _this select 1

[{	
	if (NOT_IN_VEHICLE) then {
		[PER_FRAME_HANDLER] call CBA_fnc_removePerFrameHandler;
	} 
	else {
		if (IS_CMD_AND_HAS_DRIVER) then {
			switch (TTC_driver_movementState) do {
				case 0: {objectParent player sendSimpleCommand "STOP";};
				case 1: {
					if (TTC_driver_isConfiguredVehicle) then {
						objectParent player sendSimpleCommand (TTC_driver_speedModes # TTC_driver_speedIndex);
					}
					else {
						objectParent player sendSimpleCommand TTC_driver_speedMode;
					};
				}; 
				case -1: {objectParent player sendSimpleCommand "BACK";};
				default {objectParent player sendSimpleCommand "STOP";};
			};
		};
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;