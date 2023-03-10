/* 
Adds TTC briefing to player

PARAMETERS:
	NONE

RETURNS:
	NONE
*/

player createDiarySubject ["TTC","Tek's Tank Commands"];

player createDiaryRecord ["TTC", ["Vanilla Commands", "
	Select Weapon : 1, 2, 3 ... || F || Control + F<br/>
	Select Ammo : Action menu || May be F depending on vehicle (See Marshall and Slammer)
"]];

player createDiaryRecord ["TTC", ["TTC Driver Commands", "
	You must be in the commander seat of a vehicle with an AI driver. You may turn out. Use your keyboard to command the driver.<br/>
	<br/>
	H -> Halt:<br/>
	Driver will halt the vehicle. Cancels advance and reverse order.<br/>
	<br/>
	W -> Advance:<br/>
	Driver will drive forward until the driver is told to reverse or halt.<br/>
	<br/>
	S -> Reverse: <br/>
	Driver will drive backward until the driver is told to advance or halt.<br/>
	<br/>
	A -> Turn Left, D -> Turn Right:<br/>
	Driver will turn the vehicle left or right while the key is held.<br/>
	Using the default keybinds of W/S and A/D, an unintended feature occurs where unless you hold W or S with your turn key A/D, you will not turn. <br/>
	This can be solved in one direction through adding the A and D keys to the direction key W or S. If you choose to rebind, you will not need to hold W for forward turns, but you will need to hold S when reversing and turning.<br/>
	Go to Controls<br/>
	Select SHOW: Vehicle Movement<br/>
	Go through the following keybinds and bind them - make sure to save by pressing OK!<br/> 
	Car Forward -> W, A, D<br/>
	Car Backward -> S<br/>
	Car Left -> A<br/>
	Car Right -> D<br/>
	<br/>
	Q -> Decrease Speed Limit/Mode, E -> Increase Speed Limit/Mode:<br/>
	For configured vehicles the driver can be adjusted to drive at 10/20/30/40/50/60/Unrestricted km/h.<br/>
	For unconfigured vehicles, the driver can be adjusted to drive at the three vanilla speed modes: SLOW, CONVOY(renamed from FORWARD) and FAST.
"]];

player createDiaryRecord ["TTC", ["TTC Gunner Commands", "
	You must be in the commander seat of a vehicle with an AI gunner. You may turn out. Use the Action Menu to command the gunner.<br/>
	<br/>
	Fire:<br/>
	When you are turned out, forces the gunner to fire the currently selected weapon.<br/>
	Does not work well with non-single fire weapons (40mm cannon, coaxial machine gun) due to implementation will likely fire a single round - depends on vehicle.<br/>
	<br/>
	Target Object:<br/>
	Targets the object in your crosshair and makes the gunner track the object.<br/>
	<br/>
	Target Bearing:<br/>
	Makes the gunner target the bearing and track a point at that bearing from the original call, meaning the gunner will track the point as the vehicle moves.<br/>
	<br/>
	Cancel Target:<br/>
	Makes the gunner return the turret to the front of the hull and cancels Target Object/Bearing.<br/>
	<br/>
	Watch Sector:<br/>
	Makes the gunner track the sector you are currently looking in. The gunner will track the sector even as the vehicle hull changes direction.<br/>
	There are 8 sectors, each 45 degrees wide.<br/>
	Front, Front Right, Right, Rear Right, Rear, Rear Left, Left, Front Left.<br/>
	<br/>
	If Autotargeting is enabled then the gunner will automatically target the most dangerous enemy within his sector.<br/>
	<br/>
	Stop Watching Sector:<br/>
	Makes the gunner return the turret to the front of the hull and cancels Watch Sector.<br/>
	<br/>
	Enable Autotargeting:<br/>
	Allows the gunner to automatically target any units the gunner has knowledege of.<br/>
	Will automatically cancel an order to target.<br/>
	If gunner has a Watch Sector order, the gunner will automatically target the most dangerous enemy within his sector.<br/>
	Disables manual fire.<br/>
	<br/>
	Disable Autotargeting:<br/>
	Prevents the gunner from automatically targeting any units the gunner has knowledge of.<br/>
	Will make the gunner return the turret to the front of the hull.<br/>
	Enables manual fire.
"]];

player createDiaryRecord ["TTC", ["READ ME TO NOT GO INSANE", "
	Ensure you disable the automatic callouts the commander makes when giving orders.<br/>
	Go to Controls<br/>
	Select SHOW: Command<br/>
	Go through the following keybinds and unbind them - make sure to save by pressing OK!<br/> 
	<br/>
	Command Watch<br/>
	Command Left<br/>
	Command Right<br/>
	Command Forward<br/>
	Command Back<br/>
	Command Fast<br/>
	Command Slow
"]];

player createDiaryRecord ["TTC", ["Required Mods", "
	CBA_A3
"]];