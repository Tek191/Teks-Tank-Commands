/* 
Converts the given number to a string and adds the required number of 0's
to be in the form XXX.

PARAMETERS:
	NUMBER _bearing : [0, 360]

RETURNS:
	STRING _bearing : Formatted bearing as an integer [0, 360] in the form XXX

For Example 
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