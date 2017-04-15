/*
Author:
Nicholas Clark (SENSEI)

Description:
primary task - destroy cache

Arguments:
0: forced task position <ARRAY>
1: forced base strength <NUMBER>

Return:
none
__________________________________________________________________*/
#define TASK_PRIMARY
#define TASK_NAME 'Destroy Cache'
#include "script_component.hpp"

params [
    ["_position",[],[[]]],
    ["_baseStrength",0.47 + random 0.3,[0]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_caches = [];
_cleanup = [];
_strength = TASK_STRENGTH + TASK_GARRISONCOUNT;
_vehGrp = grpNull;

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"meadow",10] call EFUNC(main,findPosTerrain);
};

if (_position isEqualTo []) exitWith {
	TASK_EXIT_DELAY(0);
};

_base = [_position,_baseStrength] call EFUNC(main,spawnBase);
_bRadius = _base select 0;
_bNodes = _base select 3;

if (_bNodes isEqualTo []) exitWith {
	(_base select 2) call EFUNC(main,cleanup);
	TASK_EXIT_DELAY(0);
};

_cleanup append (_base select 2);

_posCache = selectRandom _bNodes;
_posCache = _posCache select 0;

for "_i" from 0 to 1 do {
	_cache = "O_supplyCrate_F" createVehicle _posCache;
	_cache setDir random 360;
	_cache setVectorUp surfaceNormal getPos _cache;
    [_cache] call FUNC(handleDamage);
	_cleanup pushBack _cache;
	_caches pushBack _cache;
};

_grp = [_position,0,_strength,EGVAR(main,enemySide),TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);
_grp setVariable ["uksf_caching_excluded", true, true];

[
	{count units (_this select 0) >= (_this select 2)},
	{
        params ["_grp","_bRadius","_strength","_cleanup"];

        _cleanup append (units _grp);

        // regroup garrison units
        [
            _grp,
            TASK_GARRISONCOUNT,
            {[_this select 0,_this select 0,_this select 1,1,false] call CBA_fnc_taskDefend},
            [_bRadius],
            (count units _grp) - TASK_GARRISONCOUNT
        ] call EFUNC(main,splitGroup);

        // regroup patrols
        [
            _grp,
            TASK_PATROL_UNITCOUNT,
            {[_this select 0, _this select 0, _this select 1, 4, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [0,5,8]] call CBA_fnc_taskPatrol},
            [_bRadius],
            0,
            0.1
        ] call EFUNC(main,splitGroup);
	},
	[_grp,_bRadius,_strength,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

_vehPos = [_position,_bRadius,_bRadius + 100,8,0] call EFUNC(main,findPosSafe);

if !(_vehPos isEqualTo _position) then {
	_vehGrp = [_vehPos,1,1,EGVAR(main,enemySide),TASK_SPAWN_DELAY,true] call EFUNC(main,spawnGroup);

	[
		{{_x getVariable [ISDRIVER,false]} count (units (_this select 1)) > 0},
		{
            params ["_position","_vehGrp","_bRadius"];

            _cleanup pushBack (objectParent leader _vehGrp);
            _cleanup append (units _vehGrp);

			[_vehGrp, _position, _bRadius*2, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [5,10,15]] call CBA_fnc_taskPatrol;
		},
		[_position,_vehGrp,_bRadius]
	] call CBA_fnc_waitUntilAndExecute;
};

// SET TASK
_taskPos = ASLToAGL ([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe));
_taskDescription = format ["A %1 base, housing an ammunitions cache, has been located nearby. Destroy the cache and weaken the enemy supply lines.",[EGVAR(main,enemySide)] call BIS_fnc_sideName];
[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,0,true,"destroy"] call BIS_fnc_taskCreate;

// PUBLISH TASK
_data = [_position,_baseStrength];
TASK_PUBLISH(_data);
TASK_DEBUG(_posCache);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_cleanup","_caches","_posCache"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call BIS_fnc_taskSetState;
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if ({alive _x} count _caches isEqualTo 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
		_cleanup call EFUNC(main,cleanup);
		TASK_APPROVAL(_posCache,TASK_AV);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_cleanup,_caches,_posCache]] call CBA_fnc_addPerFrameHandler;
