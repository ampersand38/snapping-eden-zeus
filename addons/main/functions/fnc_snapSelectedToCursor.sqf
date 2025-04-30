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

// 3DEN hovered object
private _target = objNull;
if (is3DEN && {get3DENMouseOver isNotEqualTo []}) then {
    get3DENMouseOver params [["_type", ""], ["_entity", objNull]];
    if (_type == "object") then {
        _target = _entity;
    };
};
// Zeus hovered object
if (!isNull curatorCamera && {curatorMouseOver isNotEqualTo []}) then {
    curatorMouseOver params [["_type", ""], ["_entity", objNull]];
    if (_type == "object") then {
        _target = _entity;
    };
};
// Intersect
if (isNull _target) then {
    private _intersection = lineIntersectsSurfaces [
        AGLToASL positionCameraToWorld [0,0,0],
        AGLToASL screenToWorld getMousePosition,
        _object, objNull, true, 1, "GEOM", "ROADWAY"
    ] param [0, []];
    if (_intersection isEqualTo []) exitWith {};

    _intersection params ["", "", "_intersectObject"];
    if (isNull _intersectObject) exitWith {};

    _target = _intersectObject;
};

[_object, _target, -1] call FUNC(snap);
