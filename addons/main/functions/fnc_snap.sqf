#include "script_component.hpp"
/*
 * Author: Ampersand
 * Snap object.
 *
 * Arguments:
 * 0: Object <OBJECT>
 * 1: Snap To <ARRAY|OBJECT> of strings for nearestObjects or target object
 * 2: Angle <NUMBER> angle snapping increment
 * 3: Mode <NUMBER> Mode for auto calculating snap points
 *      BB_EDGEMIDPOINT 1
 *      BB_CORNER 2
 *
 * Return Value:
 * None
 *
 * Example:
 * [_object] call sez_main_fnc_snap
 * [_object, _snapToObject] call sez_main_fnc_snap
 *
 * Public: No
 */

params [
    "_object",
    ["_snapTo", ["Static"], [[], objNull]],
    ["_distance", 2],
    ["_angle", 90],
    ["_boundingBoxMode", BB_EDGEMIDPOINT]
];

if (is3DEN && {current3DENOperation != ""}) exitWith {};

if (isFilePatchingEnabled) then {
    call COMPILE_FILE(initSnapping);
};

if (sez_setting_useKeybinds && {!sez_snappingenabled}) exitWith {};
if (!sez_setting_useKeybinds && {
    (is3DEN && {current3DENOperation != "" || {get3DENActionState "MoveGridToggle" == 0}})
    || {!isNull curatorCamera && {!shownCuratorCompass}}
}) exitWith {};

if !(
    (
        toLower typeOf _object in sez_snapPointsMap
        || {toLower getText (configOf _object >> "model") in sez_snapPointsMap }
        || {(_object selectionNames "MEMORY" findIf {"snap_" in _x}) > -1}
        || {_object isKindOf "Static"}
    )
) exitWith {};

private _snapPointsThis = [_object] call FUNC(getSnapPoints);
if (_snapPointsThis isEqualTo []) exitWith {systemChat "no snap points";};
_snapPointsThis = _snapPointsThis apply {_object modelToWorldVisual _x};

private _nearbyObjects = if (_snapTo isEqualType []) then {
    nearestObjects [_object, _snapTo, 50 max (((boundingBox _object) # 2) * 2.5)] - [_object];
} else {
    [_snapTo]
};

if (_nearbyObjects isEqualTo []) exitWith {
    //systemChat "no neighbour objects";
};

private _minDistance = 1000;
private _neighbourInfo = [];
{
    private _xObject = _x;

    private _xSnapPoints = [_xObject] call FUNC(getSnapPoints);
    //systemChat str _xSnapPoints;
    _xSnapPoints = _xSnapPoints apply {_xObject modelToWorldVisual _x};
    if (isNil "_xSnapPoints" || {_xSnapPoints isEqualTo []}) then {continue;};

    private _xInfo = [_snapPointsThis, _xSnapPoints] call FUNC(nearestPair);
    _xInfo params ["_xDistance"];

    if (_xDistance < _minDistance) then {
        _minDistance = _xDistance;
        _neighbourInfo = [_xObject] + _xInfo;
    };
} forEach _nearbyObjects;

_neighbourInfo params ["_neighbour",
    "_minDistance", "_snapPointThis", "_snapPointNeighbour",
    "_minDistance_2", "_snapPointThis_2", "_snapPointNeighbour_2"
];

//systemChat str ["dist", _minDistance, _minDistance_2];

if (_minDistance == 1000) exitWith {
    //systemChat "no neighbour snap points";
};

if (_distance > 0 && {_minDistance > _distance}) exitWith {
    //systemChat format ["closest snap point %1", _minDistance];
    [
        [_snapPointNeighbour, [1,0,0,1]],
        [_snapPointThis, [1,0,0,1]]
    ] call sez_main_fnc_drawHint;
};

//systemChat str [(_snapPointThis distance _snapPointThis_2), (_snapPointNeighbour distance _snapPointNeighbour_2)];
private _isTwoPOints = _distance > 0 && {_minDistance_2 < _distance} &&
    {abs((_snapPointThis distance _snapPointThis_2)
    - (_snapPointNeighbour distance _snapPointNeighbour_2))
    < 0.1};

if (_isTwoPOints) then {
    //systemChat str "two points";
    // Reconvert to model space due to dir change
    _posModel = _object worldToModel _snapPointThis;

    private _dirNeighbour = _snapPointNeighbour getDir _snapPointNeighbour_2;
    private _dirSnapPoints = _snapPointThis getDir _snapPointThis_2;
    private _dir = getDir _object + _dirNeighbour - _dirSnapPoints;
    //systemChat str _dir;

    if (is3DEN) then {
        _object set3DENAttribute ["rotation", [0, 0, _dir]];
    } else {
        _object setDir _dir;
    };
    // Recalc position in case direction was changed
    _snapPointThis = _object modelToWorldVisual _posModel;
};

private _pos = getPosASL _object;

if (_angle > -1
    && {!_isTwoPOints}
    && {
        (sez_setting_useKeybinds && {sez_rotationenabled})
        || {
            !sez_setting_useKeybinds && {
                (is3DEN && {get3DENActionState "RotateGridToggle" == 1})
                || {!isNull curatorCamera && sez_curatorSnapAngleEnabled}
            }
        }
    }
) then {
    // Reconvert to model space due to dir change
    _posModel = _object worldToModel _snapPointThis;

    // Adjust direction
    _dirTo = getDir _neighbour - 360;
    _dirObject = getDir _object;
    _dir = _dirTo;

    for "_i" from 0 to 7 do
    {
        _dir = _dirTo + _i * 90;
        if(abs(_dir - _dirObject) < 45)then
        {
            _i = 10;
        };
    };
    if (is3DEN) then {
        _object set3DENAttribute ["rotation", [0, 0, _dir]];
    } else {
        _object setDir _dir;
    };
    // Recalc position in case direction was changed
    _snapPointThis = _object modelToWorldVisual _posModel;
};

// Transform position
_pos = _pos vectorDiff (_snapPointThis vectorDiff _snapPointNeighbour);
//_pos = [_pos # 0, _pos # 1, (getposASL _neighbour) # 2];
//systemChat format["pos found %1",_pos];

[_object, _pos] call FUNC(setPosASL);

// Snap to angled surface
if ((getPos _neighbour # 2) < 0.1
    && {
        (sez_setting_useKeybinds && {sez_terrainenabled})
        || {
            !sez_setting_useKeybinds && {
                (is3DEN && {get3DENActionState "SurfaceSnapToggle" == 1})
                || {!isNull curatorCamera && sez_curatorSnapAngleEnabled}
            }
        }
    }
) then {
    private _height = getPos _object # 2;
    _pos = _pos vectorAdd [0, 0, -_height];
    [_object, _pos] call FUNC(setPosASL);
};

if (_isTwoPOints) then {
    [
        [_snapPointNeighbour, [0,1,0,1]],
        [_snapPointThis, [1,1,0,1]],
        [_snapPointNeighbour_2, [0,1,0,1]],
        [_snapPointThis_2, [1,1,0,1]]
    ] call sez_main_fnc_drawHint;
} else {
    [
        [_snapPointNeighbour, [0,1,0,1]],
        [_snapPointThis, [1,1,0,1]]
    ] call sez_main_fnc_drawHint;
};

//systemChat format["nearby objects %1 %2 snap point %3",_neighbour,_object distance _neighbour,_snapPointsThis];
