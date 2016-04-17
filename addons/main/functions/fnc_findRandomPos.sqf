/*
Author:
Nicholas Clark (SENSEI)

Description:
finds random position

Arguments:
0: center position <ARRAY>
1: min distance from center <NUMBER>
2: max distance from center <NUMBER>
3: min distance from objects <NUMBER>
4: direction to search in <NUMBER>

Return:
array (positionASL)
__________________________________________________________________*/
#include "script_component.hpp"

private ["_center","_min","_max","_checkDist","_dir","_pos"];

_center = param [0,[],[[]]];
_min = param [1,0,[0]];
_max = param [2,100,[0]];
_checkDist = param [3,-1];
_dir = param [4,-1];

if (_dir isEqualTo -1) then {
	_dir = random 360;
};

_pos = _center getPos [floor (random ((_max - _min) + 1)) + _min, _dir];
_pos = _pos isFlatEmpty [_checkDist,-1,-1,1,-1];
if (_pos isEqualTo []) exitWith {_center};
if (floor (_pos select 2) < 0) then {
	_pos set [2,0];
};

_pos