/*
Author:
Nicholas Clark (SENSEI)

Description:
send reinforcements to position

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_center","_side","_dist","_distSpawn","_wpType","_patrol","_findHelipad","_buffer","_fnc_getCargo","_baseCfg","_numCargo","_vehType","_fnc_getNearHelipad","_helipad","_isEmpty","_pos","_range","_size","_unitPool","_vehPool","_backup","_lz","_posHelipad","_type","_veh","_grp","_pilot","_grpPatrol","_wp1","_wp2","_args","_idPFH","_wp"];

_center = param [0];
_side = param [1,GVAR(enemySide)];
_dist = param [2,300,[0]];
_distSpawn = param [3,1500,[0]];
_wpType = param [4,"SAD",[""]];
_patrol = param [5,false];
_findHelipad = param [6,false];
_buffer = 200;

_fnc_getCargo = {
	private ["_baseCfg","_numCargo"];
	params ["_vehType"];

	_baseCfg = configFile >> "CfgVehicles" >> _vehType;

	_numCargo = count ("
		if ( isText(_x >> 'proxyType') && { getText(_x >> 'proxyType') isEqualTo 'CPCargo' } ) then {
			true
		};
	"configClasses ( _baseCfg >> "Turrets" )) + getNumber ( _baseCfg >> "transportSoldier" );

	_numCargo
};

_fnc_getNearHelipad = {
	private ["_helipad","_isEmpty"];
	params ["_pos",["_range",100],["_size",8]];

	_helipad = (nearestObjects [_pos, ["Land_HelipadCircle_F","Land_HelipadCivil_F","Land_HelipadEmpty_F","Land_HelipadRescue_F","Land_HelipadSquare_F","Land_JumpTarget_F"], _range]) select 0;

	if !(isNil "_helipad") then {
		_isEmpty = (getPosASL _helipad) isFlatEmpty [_size, -1, 0.5, 6, -1, false, _helipad];
		if !(_isEmpty isEqualTo []) then {
			_pos = getPosATL _helipad;
		};
	};
	_pos
};

call {
	if (_side isEqualTo EAST) exitWith {
		_unitPool = GVAR(unitPoolEast);
		_vehPool = GVAR(airPoolEast);
		_backup = "O_Heli_Light_02_unarmed_F";
	};
	if (_side isEqualTo WEST) exitWith {
		_unitPool = GVAR(unitPoolWest);
		_vehPool = GVAR(airPoolWest);
		_backup = "B_Heli_Light_01_F";
	};
	_unitPool = GVAR(unitPoolInd);
	_vehPool = GVAR(airPoolInd);
	_backup = "I_Heli_light_03_unarmed_F";
};

_lz = [_center,_dist,_dist+_buffer,10] call FUNC(findRandomPos);

if (_lz isEqualTo _center) exitWith {
	LOG_DEBUG("Reinforcements LZ undefined.");
};

if (_findHelipad) then {
	_posHelipad = [_lz] call _fnc_getNearHelipad;
	_lz = _posHelipad;
};

_lz set [2,0];
_pos = [_lz,_distSpawn,_distSpawn+_buffer] call FUNC(findRandomPos);
_type = selectRandom _vehPool;
if (!(_type isKindOf "Helicopter") || {([_type] call _fnc_getCargo) < 1}) then {
	_type = _backup;
};

_veh = createVehicle [_type,_pos,[],0,"FLY"];
_veh flyInHeight 100;
_veh lock 3;
_grp = createGroup _side;
_grp setBehaviour "CARELESS";
_pilot = _grp createUnit [selectRandom _unitPool,_pos, [], 0, "NONE"];
_pilot moveInDriver _veh;
_pilot allowfleeing 0;
_grpPatrol = [_pos,0,(_veh emptyPositions "cargo") min 8,_side] call FUNC(spawnGroup);
{
	_x assignAsCargoIndex [_veh, _forEachIndex];
	_x moveInCargo _veh;
} forEach (units _grpPatrol);

_wp1 = _grp addWaypoint [_lz, 0];
_wp1 setWaypointType "TR UNLOAD";
_wp2 = _grp addWaypoint [_pos, 0];
_wp2 setWaypointStatements ["true", "deleteVehicle (vehicle this); deleteVehicle this;"];
LOG_DEBUG_1("Reinforcements inbound to %1.",_lz);

[{
	params ["_args","_idPFH"];
	_args params ["_center","_grpPatrol","_wpType","_patrol"];

	if (vehicle (leader _grpPatrol) isEqualTo (leader _grpPatrol)) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		LOG_DEBUG("Reinforcements complete.");
		_wp = _grpPatrol addWaypoint [_center, 0];
		_wp setWaypointType _wpType;
		_wp setWaypointSpeed "FULL";
		if (_patrol) then {
			_wp setWaypointStatements ["true", format["[units group this] call %1;",FUNC(setPatrol)]];
		} else {
			_wp setWaypointStatements ["true", format["if !(isPlayer(this findNearestEnemy this)) then {(units (group this)) call %1;}",FUNC(cleanup)]];
		};
	};
}, 1, [_center,_grpPatrol,_wpType,_patrol]] call CBA_fnc_addPerFrameHandler;

[{
	params ["_args","_idPFH"];
	_args params ["_veh","_pilot"];

	if (!alive _pilot || {vehicle _pilot isEqualTo _pilot} || {isTouchingGround _veh && (!(canMove _veh) || (fuel _veh isEqualTo 0))}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		_pilot call FUNC(cleanup);
		_veh call FUNC(cleanup);
		LOG_DEBUG("Reinforcement vehicle destroyed.");
	};
}, 1, [_veh,_pilot]] call CBA_fnc_addPerFrameHandler;