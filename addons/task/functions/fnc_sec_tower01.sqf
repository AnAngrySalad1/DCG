/*
Author:
Nicholas Clark (SENSEI)

Description:
secondary task - destroy tower

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_SECONDARY
#define TASK_NAME 'Destroy Communications Tower'
#define TOWER "Land_TTowerBig_2_F"
#include "script_component.hpp"

params [
    ["_position",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_strength = TASK_STRENGTH;
_cleanup = [];

if (!(EGVAR(main,hills) isEqualTo []) && {_position isEqualTo []}) then {
	_hillPos = (selectRandom EGVAR(main,hills)) select 0;
	_position = [_hillPos,0,100,6,0,0.5] call EFUNC(main,findPosSafe);
	if (_position isEqualTo _hillPos) then {
		_position = [];
	};
};

if (_position isEqualTo []) exitWith {
	TASK_EXIT_DELAY(0);
};

_tower = TOWER createVehicle _position;
_tower setPosATL [(getposATL _tower) select 0,(getposATL _tower) select 1,-1];
_tower setVectorUp [0,0,1];
_cleanup pushBack _tower;
[_tower] call FUNC(handleDamage);

_grp = [_position,0,_strength,EGVAR(main,enemySide),TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= (_this select 1)},
	{
		params ["_grp","_strength","_cleanup"];

        _cleanup append (units _grp);

        // regroup patrols
        [
            _grp,
            TASK_PATROL_UNITCOUNT,
            {[_this select 0, _this select 0, 50 + random 50, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [0,5,8]] call CBA_fnc_taskPatrol}
        ] call EFUNC(main,splitGroup);
	},
	[_grp,_strength,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

// SET TASK
_taskDescription = format ["Hinder %1 communications by destroying the radio tower.",[EGVAR(main,enemySide)] call BIS_fnc_sideName];
[true,_taskID,[_taskDescription,TASK_TITLE,""],_position,false,0,true,"destroy"] call BIS_fnc_taskCreate;

// PUBLISH TASK
TASK_PUBLISH(_position);
TASK_DEBUG(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_position","_cleanup","_tower"];

	if (GVAR(secondary) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call BIS_fnc_taskSetState;
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if !(alive _tower) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
		TASK_APPROVAL(_position,TASK_AV);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_position,_cleanup,_tower]] call CBA_fnc_addPerFrameHandler;
