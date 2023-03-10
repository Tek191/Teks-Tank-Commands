/* 
For configured vehicles: converts the given speed index to the speed it represents.
For non-configured vehicles: converts the given speed mode to a more suitable name.

PARAMETERS:
	None

RETURNS:
	STRING _return
*/

private _return = "";

if (TTC_driver_isConfiguredVehicle) then {
	if (TTC_driver_speedIndex isEqualTo 6) then {
		_return = "no limit";
	}
	else {
		_return = format ["%1 km/h", (TTC_driver_speedIndex + 1) * 10];
	};
} 
else {
	switch (TTC_driver_speedMode) do {
		case "SLOW": {_return = "SLOW"};
		case "FORWARD": {_return = "CONVOY"};
		case "FAST": {_return = "FAST"};
		default {};
	};
};

_return;