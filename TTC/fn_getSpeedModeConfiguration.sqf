/* 
Gets the speed modes for each speed limit for a validated configured vehicle.

PARAMETERS:
	None

RETURNS:
	ARRAY<STRING> : 7 elements
*/

#define RHINO_SPEED_MODES ["SLOW", "FAST", "FORWARD", "FORWARD", "FORWARD", "FORWARD", "FAST"]
#define RHINO "B_AFV_Wheeled_01_cannon_F"
#define RHINO_UP "B_AFV_Wheeled_01_up_cannon_F"
#define RHINO_OLIVE "B_T_AFV_Wheeled_01_cannon_F"
#define RHINO_UP_OLIVE "B_T_AFV_Wheeled_01_up_cannon_F"
#define MARSHALL_SPEED_MODES ["SLOW", "FORWARD", "FORWARD", "FORWARD", "FAST", "FAST", "FAST"]
#define MARSHALL "B_APC_Wheeled_01_cannon_F"	
#define MARSHALL_OLIVE "B_T_APC_Wheeled_01_cannon_F"
#define SLAMMER_SPEED_MODES ["SLOW", "FORWARD", "FORWARD", "FAST", "FAST", "FAST", "FAST"]
#define SLAMMER "B_MBT_01_cannon_F"
#define SLAMMER_UP "B_MBT_01_TUSK_F"
#define SLAMMER_OLIVE "B_T_MBT_01_cannon_F"
#define SLAMMER_UP_OLIVE "B_T_MBT_01_TUSK_F"
#define BASE_SPEED_MODES ["NORMAL", "NORMAL", "NORMAL", "NORMAL", "NORMAL", "NORMAL", "NORMAL"]

private _vehicle = typeOf objectParent player;
private _validVehicles = createHashMapFromArray [
												[RHINO, RHINO_SPEED_MODES],   
												[RHINO_UP, RHINO_SPEED_MODES], 
												[RHINO_OLIVE, RHINO_SPEED_MODES], 
												[RHINO_UP_OLIVE, RHINO_SPEED_MODES], 
												[MARSHALL, MARSHALL_SPEED_MODES], 
												[MARSHALL_OLIVE, MARSHALL_SPEED_MODES], 
												[SLAMMER, SLAMMER_SPEED_MODES], 
												[SLAMMER_UP, SLAMMER_SPEED_MODES], 
												[SLAMMER_OLIVE, SLAMMER_SPEED_MODES], 
												[SLAMMER_UP_OLIVE, SLAMMER_SPEED_MODES]
											];

_validVehicles getOrDefault [_vehicle, BASE_SPEED_MODES];