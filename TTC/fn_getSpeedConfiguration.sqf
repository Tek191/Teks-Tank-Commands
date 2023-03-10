/* 
Gets the speeds for each speed limit for a validated configured vehicle.

PARAMETERS:
	None

RETURNS:
	ARRAY<NUMBER> : 7 elements
*/

#define RHINO_SPEEDS [10, 13, 49, 66, 82, 98, 0]
#define RHINO "B_AFV_Wheeled_01_cannon_F"
#define RHINO_UP "B_AFV_Wheeled_01_up_cannon_F"
#define RHINO_OLIVE "B_T_AFV_Wheeled_01_cannon_F"
#define RHINO_UP_OLIVE "B_T_AFV_Wheeled_01_up_cannon_F"
#define MARSHALL_SPEEDS [10, 33, 50, 66, 33, 40, 0]
#define MARSHALL "B_APC_Wheeled_01_cannon_F"
#define MARSHALL_OLIVE "B_T_APC_Wheeled_01_cannon_F"
#define SLAMMER_SPEEDS [9, 30, 50, 26, 33, 40, 0]
#define SLAMMER "B_MBT_01_cannon_F"
#define SLAMMER_UP "B_MBT_01_TUSK_F"
#define SLAMMER_OLIVE "B_T_MBT_01_cannon_F"
#define SLAMMER_UP_OLIVE "B_T_MBT_01_TUSK_F"
#define BASE_SPEEDS [0, 0, 0, 0, 0, 0, 0]

private _vehicle = typeOf objectParent player;
private _validVehicles = createHashMapFromArray [
												[RHINO, RHINO_SPEEDS],   
												[RHINO_UP, RHINO_SPEEDS], 
												[RHINO_OLIVE, RHINO_SPEEDS], 
												[RHINO_UP_OLIVE, RHINO_SPEEDS], 
												[MARSHALL, MARSHALL_SPEEDS], 
												[MARSHALL_OLIVE, MARSHALL_SPEEDS], 
												[SLAMMER, SLAMMER_SPEEDS], 
												[SLAMMER_UP, SLAMMER_SPEEDS], 
												[SLAMMER_OLIVE, SLAMMER_SPEEDS], 
												[SLAMMER_UP_OLIVE, SLAMMER_SPEEDS]
											];

_validVehicles getOrDefault [_vehicle, BASE_SPEEDS];