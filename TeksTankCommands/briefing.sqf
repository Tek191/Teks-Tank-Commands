player createDiarySubject ["TeksTankCommands","Tek's Tank Commands"];

player createDiaryRecord ["TeksTankCommands", ["Vanilla Commands", "
	Select Weapon : 1, 2, 3 ... || F || Control + F<br/>
	Select Ammo : Action menu<br/>
	Move Vehicle : W A S D || Click on the map 
"]];

player createDiaryRecord ["TeksTankCommands", ["TTC Commands", "
	You must be in the commander seat of a vehicle with an AI gunner. You may turn out.<br/>
	Use the Action Menu to use the commands.
	<br/>
	<br/>
	Fire:<br/>
	When you are turned out, forces the gunner to fire the currently selected weapon.<br/>
	Does not work well with non-single fire weapons (40mm cannon, coaxial machine gun) due to implementation will likely fire a single round - depends on vehicle.<br/>
	<br/>
	Target Object:<br/>
	Targets the object in your crosshair and makes the gunner track the object.<br/>
	<br/>
	Target Bearing:<br/>
	Makes the gunner target the bearing and track a point at that bearing from the original call, meaning the gunner will not track the same relative bearing as vehicle moves.<br/>
	<br/>
	Cancel Target:<br/>
	Makes the gunner return the turret to the front of the hull and cancels Target Object/Bearing.<br/>
	<br/>
	<br/>
	Watch Sector:<br/>
	Makes the gunner track the sector you are currently looking in. The gunner will track the sector even as the vehicle changes direction.<br/>
	There are 8 sectors, each 45 degrees wide.<br/>
	Front, Front Right, Right, Rear Right, Rear, Rear Left, Left, Front Left.<br/>
	<br/>
	If Autotargeting is enabled then the gunner will automatically target the most dangerous enemy within his sector.<br/>
	<br/>
	Stop Watching Sector:<br/>
	Makes the gunner return the turret to the front of the hull and cancels Watch Sector.<br/>
	<br/>
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
	Enables manual fire.<br/>
"]];

player createDiaryRecord ["TeksTankCommands", ["READ ME TO NOT GO INSANE", "
	Ensure you disable the automatic callouts you as the commander will make to the AI in the vehicle chat.<br/>
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
	Command Slow<br/>
"]];

player createDiaryRecord ["TeksTankCommands", ["Required Mods", "
	CBA_A3<br/>
"]];