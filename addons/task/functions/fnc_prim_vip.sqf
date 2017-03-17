/*
Author:
Nicholas Clark (SENSEI)

Description:
primary task - rescue VIP

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_PRIMARY
#define TASK_NAME 'Rescue VIP'
#define SET_CAPTIVE(VIP) if (CHECK_ADDON_1("ace_captives")) then { [VIP, true] call ACE_captives_fnc_setHandcuffed; } else { [VIP,"Acts_AidlPsitMstpSsurWnonDnon02",2] call EFUNC(main,setAnim); }
#define SET_FREE(VIP) if (CHECK_ADDON_1("ace_captives")) then { [VIP, false] call ACE_captives_fnc_setHandcuffed; } else { VIP switchMove ""; }
#define SECURE_ID QUOTE(DOUBLES(ADDON,secureVIP))
#define SECURE_NAME "Secure VIP"
#define SECURE_STATEMENT _vip = _this select 0; _player = _this select 1; SET_FREE(_vip); [_vip] joinSilent grpNull; [_vip] joinSilent (group _player)
#define SECURE_COND (alive _target)
#include "script_component.hpp"

params [
    ["_position",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_town = [];
_cleanup = [];
_strength = TASK_STRENGTH + TASK_GARRISONCOUNT;
_vehGrp = grpNull;
_type = "";

if (_position isEqualTo []) then {
	private _center = EGVAR(main,center);
	private _distance = EGVAR(main,range);
	if (!(EGVAR(fob,anchor) isEqualTo objNull)) then {
		_center = (position EGVAR(fob,anchor));
		_distance = 6000;
	};
	_position = [_center,_distance,"house"] call EFUNC(main,findPosTerrain);
	if !(_position isEqualTo []) then {
		_position = _position select 1;
	};
};

// find return location
if !(EGVAR(main,locations) isEqualTo []) then {
    _town = selectRandom (EGVAR(main,locations) select {
        !(_position inArea [_x select 1, _x select 2,  _x select 2, 0, false, -1])
    });
};

if (_position isEqualTo [] || {_town isEqualTo []}) exitWith {
	TASK_EXIT_DELAY(0);
};

if !(EGVAR(main,vipPoolCiv) isEqualTo []) then {
    _type = selectRandom EGVAR(main,vipPoolCiv);
} else {
    _type = "C_Nikos_aged";
};

_vip = (createGroup civilian) createUnit [_type, [0,0,0], [], 0, "NONE"];
_vip setDir random 360;
_vip setPosASL _position;
_vip disableAI "ALL";
_vip enableAI "ANIM";
_vip enableAI "MOVE";
_cleanup pushBack _vip;
SET_CAPTIVE(_vip);

_action = [SECURE_ID,SECURE_NAME,{SECURE_STATEMENT},QUOTE(SECURE_COND),{},[],_vip,0,ACTIONPATH] call EFUNC(main,setAction);

_grp = [[_position,5,20] call EFUNC(main,findPosSafe),0,_strength,EGVAR(main,enemySide),true,TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);
_grp setVariable ["uksf_caching_excluded", true, true];

[
	{count units (_this select 0) >= (_this select 1)},
	{
        params ["_grp","_strength","_cleanup"];

        _cleanup append (units _grp);

        // regroup garrison units
        [
            _grp,
            TASK_GARRISONCOUNT,
            {[_this select 0,_this select 0,100,1,false] call CBA_fnc_taskDefend},
            [],
            (count units _grp) - TASK_GARRISONCOUNT
        ] call EFUNC(main,splitGroup);

        // regroup patrols
        [
            _grp,
            TASK_PATROL_UNITCOUNT,
            {[_this select 0, _this select 0, 100, 4, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [0,5,8]] call CBA_fnc_taskPatrol},
            [],
            0,
            0.1
        ] call EFUNC(main,splitGroup);
	},
	[_grp,_strength,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

_vehPos = [_position,50,100,8,0] call EFUNC(main,findPosSafe);

if !(_vehPos isEqualTo _position) then {
	_vehGrp = [_vehPos,1,1,EGVAR(main,enemySide),false,TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);
	[
		{{_x getVariable [ISDRIVER,false]} count (units (_this select 1)) > 0},
		{
            params ["_position","_vehGrp"];

            _cleanup pushBack (objectParent leader _vehGrp);
            _cleanup pushBack (units _vehGrp);

			[_vehGrp, _position, 200, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [5,10,15]] call CBA_fnc_taskPatrol;
		},
		[_position,_vehGrp,_cleanup]
	] call CBA_fnc_waitUntilAndExecute;
};

// SET TASK
_taskPos = ASLToAGL ([_position,100,150] call EFUNC(main,findPosSafe));
_taskDescription = format ["We have intel that a local VIP has been taken hostage by %3 forces. Locate %1 and safely escort him to %2.", name _vip, _town select 0, [EGVAR(main,enemySide)] call BIS_fnc_sideName];
[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,true,"meet"] call EFUNC(main,setTask);

TASK_DEBUG(getpos _vip);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_vip","_town","_cleanup","_action"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if !(alive _vip) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
        [_vip,0,_action] call EFUNC(main,removeAction);
		TASK_APPROVAL((getPos _vip),TASK_AV * -1);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT;
	};

    // if vip secured
    if (isPlayer leader group _vip) then {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        [_vip,0,_action] call EFUNC(main,removeAction);
        [_taskID,_town select 1] call BIS_fnc_taskSetDestination;

        [{
        	params ["_args","_idPFH"];
        	_args params ["_taskID","_vip","_town","_cleanup"];

            if (TASK_GVAR isEqualTo []) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
                [_taskID, "CANCELED"] call EFUNC(main,setTaskState);
                _cleanup call EFUNC(main,cleanup);
                TASK_EXIT_DELAY(30);
            };

            if !(alive _vip) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
                [_taskID, "FAILED"] call EFUNC(main,setTaskState);
                TASK_APPROVAL((getPos _vip),TASK_AV * -1);
                _cleanup call EFUNC(main,cleanup);
                TASK_EXIT;
            };

            _success = false;

            // if vip is returned to town and is alive/awake
            if (_vip inArea [_town select 1, TASK_DIST_RET, TASK_DIST_RET, 0, false, 10]) then {
                if (CHECK_ADDON_1("ace_medical")) then {
                    _success = [_vip] call ace_common_fnc_isAwake;
                } else {
                    _success = alive _vip;
                };
            };

            if (_success) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
                [_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
                TASK_APPROVAL((getPos _vip),TASK_AV);
                _cleanup call EFUNC(main,cleanup);
                TASK_EXIT;
            };
        }, TASK_SLEEP, [_taskID,_vip,_town,_cleanup]] call CBA_fnc_addPerFrameHandler;
    };
}, TASK_SLEEP, [_taskID,_vip,_town,_cleanup,_action]] call CBA_fnc_addPerFrameHandler;
