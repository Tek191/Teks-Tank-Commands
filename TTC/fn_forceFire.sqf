/* 
Gets the first available firemode for the currently selected weapon 
and forces the gunner to fire. For automatic weapons it greatly depends
on the first fire mode. It may be single fire.

PARAMETERS:
	None
	
RETURNS:
	None
*/

private _vehicle = objectParent player;
private _gunner = gunner _vehicle;
private _fireModes = getArray (configFile >> "CfgWeapons" >> currentWeapon _vehicle >> "modes");

_gunner forceWeaponFire [currentWeapon _vehicle, _fireModes # 0];