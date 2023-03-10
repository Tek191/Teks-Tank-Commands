/* 
Translates what a unit is looking at into its defined type: Infantry, Tank, Truck, Aircraft, Ship, Static,
Object (ammobox, flag) or Logic (unit).

PARAMETERS:
	OBJECT _unit : Unit looking at target

RETURNS:
	STRING : Target classification
*/
params ["_unit"];

private _objectType = _unit call BIS_fnc_objectType;
private _category = _objectType # 0;
private _type = _objectType # 1;

if (_category isEqualTo "Soldier") exitWith {"Infantry";};
if (_category isEqualTo "Logic") exitWith {"Logic Object";};
if (_category isEqualTo "Object") exitWith {"Object";};

if (_category isEqualTo "Vehicle") then {
	if (_type in ["Car", "Motorcycle"]) exitWith {"Truck";};
	if (_type in ["Tank", "TrackedAPC", "WheeledAPC"]) exitWith {"Tank";};
	if (_type in ["Helicopter", "Plane"]) exitWith {"Aircraft";};
	if (_type in ["Submarine", "Ship"]) exitWith {"Ship";};
	if (_type isEqualTo "StaticWeapon") exitWith {"Static";};
}
else {
	"Error";
};