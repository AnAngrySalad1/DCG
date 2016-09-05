/*
Author:
Nicholas Clark (SENSEI)

Description:
select task to spawn

Arguments:
0: task type <NUMBER>
1: cooldown <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
	["_type",1],
	["_cooldown",-1]
];

// if number is less than zero, serverSettings will be used
if (_cooldown < 0) then {
	_cooldown = GVAR(cooldown);
};

[{
	// primary task
	if ((_this select 0) > 0) then {
		_task = selectRandom GVAR(primaryTasks);
		if !(isNil "_task") then {
			LOG_DEBUG_1("Spawning task %1.",_task);
			[] spawn (missionNamespace getVariable [_task,{}]);
		};
	} else {
		// secondary task
		_task = selectRandom GVAR(secondaryTasks);
		if !(isNil "_task") then {
			LOG_DEBUG_1("Spawning task %1.",_task);
			[] spawn (missionNamespace getVariable [_task,{}]);
		};
	};
}, [_type], _cooldown] call CBA_fnc_waitAndExecute;