/* 
Creates CBA keybinds to manage movement forward, backward, stopping the vehicle and managing the speed of the vehicle.
Note, does not manage turning the vehicle: use A/D to turn manually. Sometimes this is bugged and you have to W/S + A/D to turn.

PARAMETERS:
	None

RETURNS:
	None

CBA_fnc_addKeybind
["ADDON_NAME", "ID", ["NAME", "TOOLTIP"], {//CODEDOWN}, {//CODEUP}, [DIK_KEY, [SHIFT, CONTROL, ALT]], EVERY_FRAME_WHEN_KEY_DOWN, DELAY_ON_KEY_DOWN, OVERWRITE_OLD_CBA_KEYBIND]
*/

#include "\a3\ui_f\hpp\defineDIKCodes.inc"
#define IS_CMD_AND_HAS_DRIVER player isEqualTo commander objectParent player && {!(isNull driver objectParent player)}

/*FORWARD*/
["TTC", "TTC_KB_forward", ["Forward", "Driver advances vehicle"], 
{
	if (TTC_driver_movementState isNotEqualTo 1 && {IS_CMD_AND_HAS_DRIVER}) then {
		TTC_driver_movementState = 1;
		player groupChat "Driver, advance";
	};
}, 
{}, [DIK_W, [false, false, false]], false, 0, true] call CBA_fnc_addKeybind;


/*BACKWARD*/
["TTC", "TTC_KB_backward", ["Backward", "Driver reverses vehicle"], 
{
	if (TTC_driver_movementState isNotEqualTo -1 && {IS_CMD_AND_HAS_DRIVER}) then {
		TTC_driver_movementState = -1;
		player groupChat "Driver, reverse";
	};
}, 
{}, [DIK_S, [false, false, false]], false, 0, true] call CBA_fnc_addKeybind;


/*HALT*/
["TTC", "TTC_KB_halt", ["Halt", "Driver halts vehicle"], 
{
	if (TTC_driver_movementState isNotEqualTo 0 && {IS_CMD_AND_HAS_DRIVER}) then {
		TTC_driver_movementState = 0;
		player groupChat "Driver, halt";
	};
}, 
{}, [DIK_H, [false, false, false]], false, 0, true] call CBA_fnc_addKeybind;


/*INCREASE SPEED LIMIT/MODE*/
["TTC", "TTC_KB_increase_speed", ["Increase Speed", "Increment speed"], 
{
	if (IS_CMD_AND_HAS_DRIVER) then {
		if (TTC_driver_isConfiguredVehicle) then {
			if (TTC_driver_speedIndex < 6) then {
				TTC_driver_speedIndex = TTC_driver_speedIndex + 1;
				objectParent player limitSpeed (TTC_driver_speeds # TTC_driver_speedIndex);
			};
			player groupChat format["Driver, speed limit to %1", call TTC_fnc_getFormattedSpeed];
		} 
		else {
			switch (TTC_driver_speedMode) do {
				case "SLOW": {TTC_driver_speedMode = "FORWARD";};
				case "FORWARD": {TTC_driver_speedMode = "FAST";};
				case "FAST": {};
				default {};
			};
			player groupChat format["Driver, speed mode to %1", call TTC_fnc_getFormattedSpeed];
		};
	};
}, 
{}, [DIK_E, [false, false, false]], false, 0, true] call CBA_fnc_addKeybind;


/*DECREASE SPEED LIMIT/MODE*/
["TTC", "TTC_KB_decrease_speed", ["Decrease Speed", "Decrement speed"], 
{
	if (IS_CMD_AND_HAS_DRIVER) then {
		if (TTC_driver_isConfiguredVehicle) then {
			if (TTC_driver_speedIndex > 0) then {
				TTC_driver_speedIndex = TTC_driver_speedIndex - 1;
				objectParent player limitSpeed (TTC_driver_speeds # TTC_driver_speedIndex);
			};
			player groupChat format["Driver, speed limit to %1", call TTC_fnc_getFormattedSpeed];
		} 
		else {
			switch (TTC_driver_speedMode) do {
				case "SLOW": {};
				case "FORWARD": {TTC_driver_speedMode = "SLOW";};
				case "FAST": {TTC_driver_speedMode = "FORWARD";};
				default {};
			};
			player groupChat format["Driver, speed mode to %1", call TTC_fnc_getFormattedSpeed];
		};
	};
}, 
{}, [DIK_Q, [false, false, false]], false, 0, true] call CBA_fnc_addKeybind;