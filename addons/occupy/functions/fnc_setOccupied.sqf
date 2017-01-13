/*
Author:
Nicholas Clark (SENSEI)

Description:
occupy locations

Arguments:
0: location name <STRING>
1: location position <ARRAY>
2: location size <NUMBER>
3: location type <STRING>
4: saved location data <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define SAFE_DIST 2
#define CHANCE_VEH_CAP 1
#define CHANCE_AIR_CAP 0.5
#define SNIPER_CAP 3
#define STATIC_CAP 2
#define CHANCE_VEH_CITY 0.5
#define CHANCE_AIR_CITY 0.25
#define SNIPER_CITY 2
#define STATIC_CITY 2
#define CHANCE_VEH_VILL 0.15
#define CHANCE_AIR_VILL 0.10
#define SNIPER_VILL 1
#define STATIC_VILL 1
#define WRECKS ["a3\structures_f\wrecks\Wreck_Car2_F.p3d","a3\structures_f\wrecks\Wreck_Car3_F.p3d","a3\structures_f\wrecks\Wreck_Car_F.p3d","a3\structures_f\wrecks\Wreck_Offroad2_F.p3d","a3\structures_f\wrecks\Wreck_Offroad_F.p3d","a3\structures_f\wrecks\Wreck_Truck_dropside_F.p3d","a3\structures_f\wrecks\Wreck_Truck_F.p3d","a3\structures_f\wrecks\Wreck_UAZ_F.p3d","a3\structures_f\wrecks\Wreck_Van_F.p3d","a3\structures_f\wrecks\Wreck_Ural_F.p3d"]

_this params ["_name","_center","_size","_type",["_data",nil]];

private _town = [_name,_center,_size,_type];
private _objArray = [];
private _officerPool = [];
private _unitPool = [];
private _taskType = "";
private _taskID = format ["L_%1", diag_tickTime];
private _position = [];

// find new position in case original is on water or not empty
if !([_center,SAFE_DIST,0] call EFUNC(main,isPosSafe)) then {
	for "_i" from 1 to _size step 2 do {
		_position = [_center,0,_i,SAFE_DIST,0] call EFUNC(main,findPosSafe);
		if !(_position isEqualTo _center) exitWith {};
	};
} else {
	_position = _center;
};

_position = ASLtoAGL _position;

// spawn vehicle wrecks
for "_i" from 0 to (ceil random 3) do {
	_vehPos = [_position,0,_size,8,0] call EFUNC(main,findPosSafe);

	if (!(_vehPos isEqualTo _position) && {!isOnRoad _vehPos}) then {
		private _veh = createSimpleObject [selectRandom WRECKS,[0,0,0]];
		_veh setDir random 360;
		_veh setPosASL _vehPos;
		_veh setVectorUp surfaceNormal _vehPos;
		private _fx = "test_EmptyObjectForSmoke" createVehicle [0,0,0];
		_fx setPosASL (getPosWorld _veh);
		_objArray pushBack _veh;
	};
};

call {
	if (EGVAR(main,enemySide) isEqualTo EAST) exitWith {
		_officerPool = EGVAR(main,officerPoolEast);
		_unitPool = EGVAR(main,unitPoolEast);
	};
	if (EGVAR(main,enemySide) isEqualTo WEST) exitWith {
		_officerPool = EGVAR(main,officerPoolWest);
		_unitPool = EGVAR(main,unitPoolWest);
	};
    if (EGVAR(main,enemySide) isEqualTo RESISTANCE) exitWith {
        _officerPool = EGVAR(main,officerPoolInd);
    	_unitPool = EGVAR(main,unitPoolInd);
    };
};

private _grp = createGroup EGVAR(main,enemySide);
private _officer = _grp createUnit [selectRandom _officerPool, _position, [], 0, "NONE"];
_officer setVariable [QUOTE(DOUBLES(ADDON,officer)),true,true];
SET_UNITVAR(_officer);
[_grp,_size*0.25] call EFUNC(main,setPatrol);

call {
	if (COMPARE_STR(_type,"NameCityCapital")) exitWith {
		_taskType = "Capital";
		_count = ceil (((GVAR(infCountCapital) * (count allPlayers)) min 150) max 40);
		if (isNil "_data") then {
			PREP_INF(_position,_count,_size);
			PREP_VEH(_position,ceil GVAR(vehCountCapital),_size,CHANCE_VEH_CAP);
			PREP_AIR(_position,ceil GVAR(airCountCapital),CHANCE_AIR_CAP);
		} else {
			PREP_INF(_position,ceil (_data select 0),_size);
			PREP_VEH(_position,ceil (_data select 1),_size,1);
			PREP_AIR(_position,ceil (_data select 2),1);
		};
		PREP_GARRISON(_position,ceil (_count / 1.5),_size,_unitPool);
		PREP_STATIC(_position,STATIC_CAP,_size,_objArray);
		PREP_SNIPER(_position,SNIPER_CAP,_size);
	};

	if (COMPARE_STR(_type,"NameCity")) exitWith {
		_taskType = "City";
		_count = ceil (((GVAR(infCountCity) * (count allPlayers)) min 150) max 40);
		if (isNil "_data") then {
			PREP_INF(_position,_count,_size);
			PREP_VEH(_position,ceil GVAR(vehCountCity),_size,CHANCE_VEH_CITY);
			PREP_AIR(_position,ceil GVAR(airCountCity),CHANCE_AIR_CITY);
		} else {
			PREP_INF(_position,ceil (_data select 0),_size);
			PREP_VEH(_position,ceil (_data select 1),_size,1);
			PREP_AIR(_position,ceil (_data select 2),1);
		};
		PREP_GARRISON(_position,ceil (_count / 1.5),_size,_unitPool);
		PREP_STATIC(_position,STATIC_CITY,_size,_objArray);
		PREP_SNIPER(_position,SNIPER_CITY,_size);
	};

    if (COMPARE_STR(_type,"NameVillage")) exitWith {
    	_taskType = "Village";
    	_count = ceil (((GVAR(infCountVillage) * (count allPlayers)) min 150) max 40);
    	if (isNil "_data") then {
    		PREP_INF(_position,_count,_size);
    		PREP_VEH(_position,ceil GVAR(vehCountVillage),_size,CHANCE_VEH_VILL);
    		PREP_AIR(_position,ceil GVAR(airCountVillage),CHANCE_AIR_VILL);
    	} else {
    		PREP_INF(_position,ceil (_data select 0),_size);
    		PREP_VEH(_position,ceil (_data select 1),_size,1);
    		PREP_AIR(_position,ceil (_data select 2),1);
    	};
	    PREP_GARRISON(_position,ceil (_count / 1.5),_size,_unitPool);
    	PREP_STATIC(_position,STATIC_VILL,_size,_objArray);
    	PREP_SNIPER(_position,SNIPER_VILL,_size);
    };
};

GVAR(locations) pushBack _town; // set as occupied location
//EGVAR(civilian,blacklist) pushBack _name; // stop civilians from spawning in location

[true,_taskID,[format ["Enemy forces have occupied %1! Liberate the %2!",_name,tolower _taskType],format ["Liberate %1", _taskType],""],_position,false,true,"rifle"] call EFUNC(main,setTask);

[{
	params ["_args","_idPFH"];
	_args params ["_town","_objArray","_officer","_taskID"];

	if !(([ASLToAGL(_town select 1),_town select 2] call EFUNC(main,getNearPlayers)) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		_args call FUNC(handleOccupied);
	};
}, 5, [_town,_objArray,_officer,_taskID]] call CBA_fnc_addPerFrameHandler;

private _mrk = createMarker [format["%1_%2_debug",QUOTE(ADDON),_name],_position];
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerSize [_size,_size];
_mrk setMarkerColor format ["Color%1", EGVAR(main,enemySide)];
_mrk setMarkerBrush "SolidBorder";
[_mrk] call EFUNC(main,setDebugMarker);

INFO_2("%1, %2",_town,count _objArray);
