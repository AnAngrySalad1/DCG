/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_INIT;

CHECK_ADDON;

[
	{DOUBLES(PREFIX,main)},
	{
		[[],{
 			if (hasInterface && {isNil "ace_respawn_savePreDeathGear" || !(ace_respawn_savePreDeathGear)}) then {
 				player addEventHandler ["Killed",{
 					player setVariable [UNITGEAR, getUnitLoadout player];
    					player setVariable [UNITWEAPON, [currentWeapon player, currentMuzzle player, currentWeaponMode player]];
 				}];
 				player addEventHandler ["Respawn",{
 				    [player,player getVariable UNITGEAR,player getVariable UNITWEAPON] call FUNC(restoreLoadout);
 				}];
 			};
 		}] remoteExecCall [QUOTE(BIS_fnc_call),0,true];
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;
