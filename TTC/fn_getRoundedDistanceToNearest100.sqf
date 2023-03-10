/* 
Divides the range by a 100 and rounds to the nearest integer,
then multiplies the range by a 100 to return to the original magnitude.

PARAMETERS:
	NUMBER _distance : Positive number

RETURNS:
	NUMBER _distance : Integer rounded to the nearest 100m
*/
params ["_distance"];

_distance = (round ((_distance) / 100)) * 100;

_distance;