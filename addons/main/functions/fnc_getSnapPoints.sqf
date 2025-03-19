#include "script_component.hpp"
/*
 * Author: Ampersand
 * Returns the snap points for the given object.
 *
 * Arguments:
 * 0: Object <OBJECT>
 * 1: Mode <NUMBER> Mode for auto calculating snap points
 *
 * Return Value:
 * None
 *
 * Example:
 * [_object] call sez_main_fnc_getSnapPoints
 *
 * Public: No
 */

#define LOD_MEMORY 1e15
#define SIDE_LENGTH 0.4
params ["_object", ["_boundingBoxMode", 0]];

if (isNil "_object" || {!(_object isEqualType objNull)}) exitWith { [] };

//if (isNil "sez_snapPointsMap") then {sez_snapPointsMap = createHashMap;};
sez_snapPointsMap getOrDefaultCall [toLower getText (configOf _object >> "model"), {
sez_snapPointsMap getOrDefaultCall [toLower typeOf _object, {
    private _selections = (_object selectionNames LOD_MEMORY) select {"snap" in _x} apply {_object selectionPosition [_x, LOD_MEMORY]};
    if (!isNil "_selections" && {_selections isNotEqualTo []}) then { _boundingBoxMode = BB_MEMORYPOINTS };

    flatten (0 boundingBoxReal _object) params ["_x1", "_y1", "_z1", "_x2", "_y2", "_z2"];
    if (_boundingBoxMode == 0) then {
        _boundingBoxMode = {_x} count [abs _x2 > SIDE_LENGTH, abs _y2 > SIDE_LENGTH];
    };
    //systemChat str [_boundingBoxMode, time, _x2, _y2];
    //systemChat str ["_boundingBoxMode", _boundingBoxMode];
    if (_boundingBoxMode == 0) exitWith { [] };

    //systemChat format ["%1: auto %2", typeOf _object, ["none", "midpoints", "corners", "mempts"] select _boundingBoxMode];
    switch (_boundingBoxMode) do {
        case (BB_EDGEMIDPOINT): {
            private _points = [];
            if (abs _x2 > SIDE_LENGTH) then {
                _points = _points + [
                    [_x1, _y1, _z1] vectorAdd [_x1, _y2, _z1] vectorMultiply 0.5,
                    [_x2, _y1, _z1] vectorAdd [_x2, _y2, _z1] vectorMultiply 0.5
                ];
                if (abs _z2 > SIDE_LENGTH) then {
                    _points = _points + [
                        [_x1, _y1, _z2] vectorAdd [_x1, _y2, _z2] vectorMultiply 0.5,
                        [_x2, _y1, _z2] vectorAdd [_x2, _y2, _z2] vectorMultiply 0.5
                    ];
                };
            };
            if (abs _y2 > SIDE_LENGTH) then {
                _points = _points + [
                    [_x1, _y1, _z1] vectorAdd [_x2, _y1, _z1] vectorMultiply 0.5,
                    [_x1, _y2, _z1] vectorAdd [_x2, _y2, _z1] vectorMultiply 0.5
                ];
                if (abs _z2 > SIDE_LENGTH) then {
                    _points = _points + [
                        [_x1, _y1, _z2] vectorAdd [_x2, _y1, _z2] vectorMultiply 0.5,
                        [_x1, _y2, _z2] vectorAdd [_x2, _y2, _z2] vectorMultiply 0.5
                    ];
                };
            };
            //systemChat str _points;
            _points
        };
        case (BB_CORNER): {
            [
                [_x1, _y1, _z1],
                [_x1, _y2, _z1],
                [_x2, _y1, _z1],
                [_x2, _y2, _z1]
            ] + ([[], [
                [_x1, _y1, _z2],
                [_x1, _y2, _z2],
                [_x2, _y1, _z2],
                [_x2, _y2, _z2]
            ]] select (abs _z2 > SIDE_LENGTH))
        };
        case (BB_MEMORYPOINTS): {
            _selections
        };
    };
}, true];
}, true];
