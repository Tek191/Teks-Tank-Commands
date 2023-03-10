/* 
Gets the bearing between the hull and Commander's vision relative to North.
The calculated bearing is where the player is looking with reference to the hull instead 
of North.

PARAMETERS:
	OBJECT _commander : Unit requesting bearing

RETURNS:
	NUMBER _bearing : bearing relative to Hull

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

private _vehicle = objectParent _commander;
private _driver = driver _vehicle;

private _hullBearing = ([_driver] call CBA_fnc_viewDir) # 0;
private _commanderBearing = ([_commander] call CBA_fnc_viewDir) # 0;

private _bearing = _commanderBearing - _hullBearing;

if (_bearing < 0) then {
	_bearing = 360 + _bearing;
};

_bearing;