#include "script_component.hpp"
/*
 * Author: Ampersand
 * Returns the 3DEN Rotation Attribute for a given orienation.
 *
 * Arguments:
 * 0: Vector Direction <ARRAY> Normalized
 * 1: Vector Up <ARRAY> Normalized
 *
 * Return Value:
 * 0: 3DEN Rotation <ARRAY> [x, y, z]
 *
 * Example:
 * [_vDir, _vUp] call sez_main_fnc_vectorTo3DENRotation
 * _entity set3DENAttribute ["Rotation", [_vDir, _vUp] call sez_main_fnc_vectorTo3DENRotation]
 *
 * Public: Yes
 */

params ["_vy", "_vz"];

_vx = _vy vectorCrossProduct _vz;
_rv = [_vz, _vy, _vx];

_r0 = [[0,0,1], [0,1,0], [1,0,0]];

_r = _r0 matrixMultiply matrixTranspose _rv;

[
    (_r select 1 select 0) atan2 (_r select 0 select 0),
    asin -(_r select 2 select 0),
    (_r select 2 select 1) atan2 (_r select 2 select 2)
]
