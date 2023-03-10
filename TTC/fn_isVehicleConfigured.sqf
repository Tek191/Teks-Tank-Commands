/* 
Check if current player vehicle has its speed configured.

PARAMETERS:
	None

RETURNS:
	BOOLEAN
*/

#define RHINO "B_AFV_Wheeled_01_cannon_F"
#define RHINO_UP "B_AFV_Wheeled_01_up_cannon_F"
#define RHINO_OLIVE "B_T_AFV_Wheeled_01_cannon_F"
#define RHINO_UP_OLIVE "B_T_AFV_Wheeled_01_up_cannon_F"
#define MARSHALL  "B_APC_Wheeled_01_cannon_F"
#define MARSHALL_OLIVE "B_T_APC_Wheeled_01_cannon_F"
#define SLAMMER "B_MBT_01_cannon_F"
#define SLAMMER_UP "B_MBT_01_TUSK_F"
#define SLAMMER_OLIVE "B_T_MBT_01_cannon_F"
#define SLAMMER_UP_OLIVE "B_T_MBT_01_TUSK_F"
#define VEHICLE_CLASS_NAME typeOf objectParent player

private _validVehicles = createHashMapFromArray [
												[RHINO, true],   
												[RHINO_UP, true], 
												[RHINO_OLIVE, true], 
												[RHINO_UP_OLIVE, true], 
												[MARSHALL, true], 
												[MARSHALL_OLIVE, true], 
												[SLAMMER, true], 
												[SLAMMER_UP, true], 
												[SLAMMER_OLIVE, true], 
												[SLAMMER_UP_OLIVE, true]
											];

_validVehicles getOrDefault [VEHICLE_CLASS_NAME, false];