/* 
Adds TTC actions to player

PARAMETERS:
	NONE

RETURNS:
	NONE
*/

#define HAS_CMD_AND_GNR player isEqualTo commander objectParent player && {!(isNull gunner objectParent player)}
#define AUTOTARGET_DISABLED !((gunner objectParent player) checkAIFeature 'AUTOTARGET')
#define AUTOTARGET_ENABLED (gunner objectParent player) checkAIFeature 'AUTOTARGET'
#define WEAPON_READY weaponState [objectParent player, objectParent player unitTurret gunner objectParent player, currentWeapon objectParent player] select 5 isEqualTo 0

player addAction
["FIRE",	
{
	params ["_target", "_caller", "_actionId", "_arguments"]; 
	call TTC_fnc_forceFire;
}, nil, 999, true, false, "", toString {isTurnedOut player && {HAS_CMD_AND_GNR && {WEAPON_READY}}}, -1, false, "", ""];

player addAction
["TARGET OBJECT",	
{
	params ["_target", "_caller", "_actionId", "_arguments"]; 
	call TTC_fnc_orderTargetUnit;
}, nil, 999, true, false, "", toString {HAS_CMD_AND_GNR}, -1, false, "", ""];

player addAction
["TARGET BEARING",	
{
	params ["_target", "_caller", "_actionId", "_arguments"]; 
	call TTC_fnc_orderSetTurretDirection;
}, nil, 999, true, false, "", toString {HAS_CMD_AND_GNR}, -1, false, "", ""];

player addAction
["CANCEL TARGET",	
{
	params ["_target", "_caller", "_actionId", "_arguments"]; 
	call TTC_fnc_cancelGunnerTarget;
}, nil, 999, true, false, "", toString {TTC_gunner_hasTargetOrder && {HAS_CMD_AND_GNR}}, -1, false, "", ""];

player addAction
["WATCH SECTOR",	
{
	params ["_target", "_caller", "_actionId", "_arguments"]; 
	call TTC_fnc_orderWatchSector;
}, nil, 999, true, false, "", toString {!TTC_gunner_hasWatchSectorOrder && {HAS_CMD_AND_GNR}}, -1, false, "", ""];

player addAction
["STOP WATCHING SECTOR",	
{
	params ["_target", "_caller", "_actionId", "_arguments"]; 
	call TTC_fnc_stopWatchingSector;
}, nil, 999, true, false, "", toString {TTC_gunner_hasWatchSectorOrder && {HAS_CMD_AND_GNR}}, -1, false, "", ""];

player addAction
["ENABLE AUTOTARGETING",	
{
	params ["_target", "_caller", "_actionId", "_arguments"]; 
	call TTC_fnc_enableGunnerAutoTargeting;
}, nil, 999, true, false, "", toString {!TTC_gunner_hasTargetOrder && {HAS_CMD_AND_GNR && {AUTOTARGET_DISABLED}}}, -1, false, "", ""];

player addAction
["DISABLE AUTOTARGETING",	
{
	params ["_target", "_caller", "_actionId", "_arguments"]; 
	call TTC_fnc_disableGunnerAutoTargeting;
}, nil, 999, true, false, "", toString {!TTC_gunner_hasTargetOrder && {HAS_CMD_AND_GNR && {AUTOTARGET_ENABLED}}}, -1, false, "", ""];