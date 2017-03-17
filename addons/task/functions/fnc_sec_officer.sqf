/*
Author:
Nicholas Clark (SENSEI)

Description:
secondary task - kill officer

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_SECONDARY
#define TASK_NAME 'Eliminate Officer'
#define SAFE_DIST 4
#define SAFE_GRAD 0.4
#include "script_component.hpp"

params [
    ["_position",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_classes = [];
_cleanup = [];
_strength = TASK_STRENGTH;

if (_position isEqualTo [] && {!(EGVAR(main,locals) isEqualTo [])}) then {
    _position = (selectRandom EGVAR(main,locals)) select 1;
};

if (!(_position isEqualTo []) && {!([_position,SAFE_DIST,0,SAFE_GRAD] call EFUNC(main,isPosSafe))}) then {
	_position = [_position,4,64,SAFE_DIST,0,SAFE_GRAD] call EFUNC(main,findPosSafe);
};

if (_position isEqualTo []) exitWith {
	TASK_EXIT_DELAY(0);
};

call {
	if (EGVAR(main,enemySide) isEqualTo EAST) exitWith {
		_classes = EGVAR(main,officerPoolEast);
	};
	if (EGVAR(main,enemySide) isEqualTo WEST) exitWith {
		_classes = EGVAR(main,officerPoolWest);
	};
	if (EGVAR(main,enemySide) isEqualTo RESISTANCE) exitWith {
		_classes = EGVAR(main,officerPoolInd);
	};
};

_base = [_position,random 0.2] call EFUNC(main,spawnBase);
_bRadius = _base select 0;
_cleanup append (_base select 2);

_officer = (createGroup EGVAR(main,enemySide)) createUnit [selectRandom _classes, ASLtoAGL _position, [], 0, "NONE"];
_cleanup pushBack _officer;
[group _officer,_position,_bRadius,1,false] call CBA_fnc_taskDefend;

_grp = [_position,0,_strength,EGVAR(main,enemySide),true,TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);
_grp setVariable ["uksf_caching_excluded", true, true];

[
	{count units (_this select 0) >= (_this select 2)},
	{
        params ["_grp","_bRadius","_strength","_cleanup"];

        _cleanup append (units _grp);

        // regroup patrols
        [
            _grp,
            TASK_PATROL_UNITCOUNT,
            {[_this select 0, _this select 0, (_this select 1) max 40, 4, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [0,5,8]] call CBA_fnc_taskPatrol},
            [_bRadius],
            0,
            0.1
        ] call EFUNC(main,splitGroup);
	},
	[_grp,_bRadius,_strength,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

// SET TASK
_taskPos = ASLToAGL ([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe));
_taskDescription = format ["A low ranking %1 officer has been spotted nearby. Find and eliminate the officer.",[EGVAR(main,enemySide)] call BIS_fnc_sideName];
[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,true,"kill"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_officer","_cleanup","_position"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if !(alive _officer) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(_position,TASK_AV);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_officer,_cleanup,_position]] call CBA_fnc_addPerFrameHandler;
