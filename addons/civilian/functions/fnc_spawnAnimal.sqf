/*
Author:
Nicholas Clark (SENSEI)

Description:
spawns animals

Arguments:
0: position to spawn <ARRAY>
1: types to spawn <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_pos","_types"];

private _agentList = [];

_id = str _pos;

missionNamespace setVariable [LOCVAR(_id),true];

for "_i" from 1 to 10 do {
	private _agent = createAgent [selectRandom _types, _pos, [], 150, "NONE"];
	_agentList pushBack _agent;
};

[{
	params ["_args","_idPFH"];
	_args params ["_pos","_agentList"];

	if ({CHECK_DIST(_x,_pos,GVAR(spawnDist))} count allPlayers isEqualTo 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		missionNamespace setVariable [LOCVAR(_id),false];
		_agentList call EFUNC(main,cleanup);
	};
}, 30, [_pos,_agentList]] call CBA_fnc_addPerFrameHandler;