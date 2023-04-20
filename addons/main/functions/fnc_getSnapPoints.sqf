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

params ["_object", ["_boundingBoxMode", 0]];

if (isNil "_object" || {!(_object isEqualType objNull)}) exitWith {[]};

//if (isNil "snapPointsMap") then {snapPointsMap = createHashMap;};
snapPointsMap getOrDefaultCall [typeOf _object, {
	flatten (0 boundingBoxReal _object) params ["_x1", "_y1", "_z1", "_x2", "_y2", "_z2"];
	if (_boundingBoxMode == 0) then {
		_boundingBoxMode = {_x} count [_x2 > 0.5, _y2 > 0.5];
	};
    if (_boundingBoxMode == 0) exitWith { [] };

    systemChat format ["%1: auto %2", typeOf _object, ["none", "midpoints", "corners"] select _boundingBoxMode];
	switch (_boundingBoxMode) do {
	    case (BB_EDGEMIDPOINT): {
			private _points = [];
			if (_xSize > 0.5) then {
				_points = _points + [
					[_x1, _y1, _z1] vectorAdd [_x1, _y2, _z1] vectorMultiply 0.5,
					[_x2, _y1, _z1] vectorAdd [_x2, _y2, _z1] vectorMultiply 0.5
			    ]
			};
			if (_ySize > 0.5) then {
				_points = _points + [
					[_x1, _y1, _z1] vectorAdd [_x2, _y1, _z1] vectorMultiply 0.5,
					[_x1, _y2, _z1] vectorAdd [_x2, _y2, _z1] vectorMultiply 0.5
			    ]
			};
			_points
		};
	    case (BB_CORNER): {
			[
 	   			[_x1, _y1, _z1],
 	   			[_x1, _y2, _z1],
 	   			[_x2, _y1, _z1],
 	   			[_x2, _y2, _z1],
 	   			[_x1, _y1, _z2],
 	   			[_x1, _y2, _z2],
 	   			[_x2, _y1, _z2],
 	   			[_x2, _y2, _z2]
 	   		]
		};
	};
}, true];
