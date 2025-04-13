#include "script_component.hpp"
/*
* Author: Ampersand
* Snap selected object to object under cursor.
*
* Arguments:
* None
*
* Return Value:
* None
*
* Example:
* [] call sez_main_fnc_snapSelectedToCursor
*
* Public: No
*/

private _object = objNull;
if (is3DEN) then {
    _object = get3DENSelected "object" param [0, objNull];
};
if (!isNull curatorCamera) then {
    _object = curatorSelected select 0 param [0, objNull];
};

if (isNull _object) exitWith {};

private _intersection = lineIntersectsSurfaces [
    AGLToASL positionCameraToWorld [0,0,0],
    AGLToASL screenToWorld getMousePosition,
    _object, objNull, true, 1, "GEOM", "ROADWAY"
] param [0, []];
if (_intersection isEqualTo []) exitWith {};

_intersection params ["", "", "_intersectObject"];
if (isNull _intersectObject) exitWith {};

[_object, _intersectObject, -1] call FUNC(snap);
