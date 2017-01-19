/*
Author:
Nicholas Clark (SENSEI)

Description:
run patrol handler

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

// delete null and lonely groups
if !(GVAR(groups) isEqualTo []) then {
	for "_i" from (count GVAR(groups) - 1) to 0 step -1 do {
		_grp = GVAR(groups) select _i;

		if (isNull _grp || {([getPosATL (leader _grp),PATROL_RANGE] call EFUNC(main,getNearPlayers) isEqualTo []) && !(behaviour (leader _grp) isEqualTo "COMBAT")}) then {
			if !(isNull _grp) then {
				{
					deleteVehicle _x;
				} forEach (units _grp);
				deleteGroup _grp;
			};
			GVAR(groups) deleteAt _i;
		};
	};
};

if (count GVAR(groups) <= ceil GVAR(groupsMaxCount)) then {
	_HCs = entities "HeadlessClient_F";
	_players = allPlayers - _HCs;

	if !(_players isEqualTo []) then {
		_player = selectRandom _players;
		_players = [getPosASL _player,100] call EFUNC(main,getNearPlayers);

		if ({_player inArea [_x select 0,_x select 1,_x select 1,0,false,-1]} count GVAR(blacklist) isEqualTo 0) then { // check if player is in a blacklist array
			_posArrayCheck = [getpos _player,100,PATROL_RANGE,PATROL_MINRANGE,10] call EFUNC(main,findPosGrid);
			_posArray = [];
			/*private _distance = if (!(isNull EGVAR(fob,anchor)) then {
				(((([position EGVAR(fob,anchor)] call EFUNC(approval,getValue)) * 8) max 300) min 800)
			} else {
				800
			};*/
			{ // remove positions in blacklist, that are near players or that players can see
				_y = _x;
				/*private _distanceCheck = if (isNull EGVAR(fob,anchor)) then {
					false
				} else {
					(EGVAR(fob,anchor) distance2D _y <= _distance)
				};*/
				if ({_y inArea [_x select 0,_x select 1,_x select 1,0,false,-1]} count GVAR(blacklist) > 0 ||
				    //_distanceCheck ||
				    {!([_y,100] call EFUNC(main,getNearPlayers) isEqualTo [])} ||
					{{[_y,eyePos _x] call EFUNC(main,inLOS)} count _players > 0}) then {
					_posArray deleteAt _forEachIndex;
				};
			} forEach _posArrayCheck;
			if !(_posArray isEqualTo []) then {
				_grp = grpNull;
				_pos = ASLtoAGL (selectRandom _posArray);
				if (random 1 < GVAR(vehChance)) then {
					_grp = [_pos,1,1,EGVAR(main,enemySide),false,1,true] call EFUNC(main,spawnGroup);
					[
						{count units (_this select 0) > 0},
						{
							[_this select 0, _this select 0, PATROL_RANGE, 5, "MOVE", GVAR(mode), "YELLOW", GVAR(speed), "STAG COLUMN", "if (random 1 < 0.2) then {this spawn CBA_fnc_searchNearby}", [5,10,15]] call CBA_fnc_taskPatrol;
						},
						[_grp]
					] call CBA_fnc_waitUntilAndExecute;

					INFO_1("Spawning vehicle patrol at %1",_pos);
				} else {
					_count = 6;
					_grp = [_pos,0,_count,EGVAR(main,enemySide),false,2] call EFUNC(main,spawnGroup);
					[
						{count units (_this select 0) isEqualTo (_this select 2)},
						{
							_this params ["_grp","_player","_count"];

							// set waypoint around target player
							_wp = _grp addWaypoint [getPosATL _player,0];
							_wp setWaypointCompletionRadius 100;
							_wp setWaypointBehaviour GVAR(mode);
							_wp setWaypointFormation "STAG COLUMN";
							_wp setWaypointSpeed GVAR(speed);
							_wp setWaypointStatements [
                                "!(behaviour this isEqualTo ""COMBAT"")",
                                format ["[this, this, %1, 5, ""MOVE"", %2, ""YELLOW"", %3, ""STAG COLUMN"", """", [0,0,0]] call CBA_fnc_taskPatrol;",PATROL_RANGE, QGVAR(mode), QGVAR(speed)]
                            ];
						},
						[_grp,_player,_count]
					] call CBA_fnc_waitUntilAndExecute;

					INFO_1("Spawning infantry patrol at %1",_pos);
				};
				GVAR(groups) pushBack _grp;
			};
		};
	};
};
