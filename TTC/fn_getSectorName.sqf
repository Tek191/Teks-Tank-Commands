/* 
360 degrees are split into 8 sectors in clockwise fashion.
Translates the sector number into its name.

PARAMETERS:
	NUMBER _sectorIndex : [0, 7]

RETURNS:
	STRING _sectorName 
*/	
params ["_sectorIndex"];
private ["_sectorName"];

switch (_sectorIndex) do {
	case 0: {_sectorName = "Front";};
	case 1: {_sectorName = "Front Right";};
	case 2: {_sectorName = "Right";};
	case 3: {_sectorName = "Rear Right";};
	case 4: {_sectorName = "Rear";};
	case 5: {_sectorName = "Rear Left";};
	case 6: {_sectorName = "Left";};
	case 7: {_sectorName = "Front Left";};
	default {_sectorName = "ERROR";};
};	

_sectorName;