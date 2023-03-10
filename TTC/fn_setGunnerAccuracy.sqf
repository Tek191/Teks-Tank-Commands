/* 
Reduces gunner error in aiming. Done to not make the player feel cheated,
may lead to an overtuned gunner though this is preferred over an underwhelming one.

PARAMETERS:
	None

RETURNS:
	None
*/

private _gunner = gunner objectParent player;
{_gunner setSkill [_x, 1]} forEach ["aimingAccuracy", "aimingSpeed", "aimingShake"];