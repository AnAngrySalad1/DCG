/*
Author:
Nicholas Clark (SENSEI)

Description:
secondary task - find intel 02

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_SECONDARY
#define TASK_NAME 'Find Map Intel'
#define INTEL_CLASS QUOTE(ItemMap)
#define INTEL_CONTAINER GVAR(DOUBLES(intel02,container))
#define UNITCOUNT 8
#include "script_component.hpp"

params [
    ["_position",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_classes = [];
_cleanup = [];
INTEL_CONTAINER = objNull;

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"house"] call EFUNC(main,findPosTerrain);

    if !(_position isEqualTo []) then {
        _position = _position select 1;
    };
};

if (_position isEqualTo []) exitWith {
	TASK_EXIT_DELAY(0);
};

call {
	if (EGVAR(main,enemySide) isEqualTo EAST) exitWith {
		_classes = EGVAR(main,vehPoolEast);
	};
	if (EGVAR(main,enemySide) isEqualTo WEST) exitWith {
		_classes = EGVAR(main,vehPoolWest);
	};
	if (EGVAR(main,enemySide) isEqualTo RESISTANCE) exitWith {
		_classes = EGVAR(main,vehPoolInd);
	};
};

_grp = [_position,0,UNITCOUNT,EGVAR(main,enemySide),TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= UNITCOUNT},
	{
		params ["_grp","_cleanup"];

        _cleanup append (units _grp);
        removeFromRemainsCollector units _grp;

		{
			removeAllAssignedItems _x;
			removeHeadgear _x;
            removeVest _x;
			_x setVariable ["uksf_cleanup_excluded", true, true];
		} forEach (units _grp);

        {
            leader _grp removeItemFromUniform _x;
        } forEach (uniformItems leader _grp);

        INTEL_CONTAINER = [leader _grp,INTEL_CLASS] call FUNC(addItem);

        // regroup patrols
        [
            _grp,
            2,
            {[_this select 0, _this select 0, 30, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [0,5,8]] call CBA_fnc_taskPatrol}
        ] call EFUNC(main,splitGroup);
	},
	[_grp,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

// SET TASK
_taskDescription = format ["Aerial reconnaissance spotted a %1 fireteam patrolling a nearby settlement. Ambush the unit and search the enemy combatants for intel.",[EGVAR(main,enemySide)] call BIS_fnc_sideName];
[true,_taskID,[_taskDescription,TASK_TITLE,""],_position,false,0,true,"search"] call BIS_fnc_taskCreate;

// PUBLISH TASK
TASK_PUBLISH(_position);
TASK_DEBUG(_position);

// TASK HANDLER
[{
    params ["_args","_idPFH"];
    _args params ["_taskID","_grp","_cleanup"];

    if (TASK_GVAR isEqualTo []) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        [_taskID, "CANCELED"] call BIS_fnc_taskSetState;
        _cleanup call EFUNC(main,cleanup);
        TASK_EXIT_DELAY(30);
    };

    if (!isNull INTEL_CONTAINER && {{COMPARE_STR(INTEL_CLASS,_x)} count itemCargo INTEL_CONTAINER < 1}) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        [_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
        TASK_APPROVAL(getPos (leader _grp),TASK_AV);
        _cleanup call EFUNC(main,cleanup);
        TASK_EXIT;
    };
}, TASK_SLEEP, [_taskID,_grp,_cleanup]] call CBA_fnc_addPerFrameHandler;
