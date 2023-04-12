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

//if (isNil "snapPointsMap") then {snapPointsMap = createHashMap;};
snapPointsMap getOrDefaultCall [typeOf _object, {
	flatten (0 boundingBoxReal _object) params ["_x1", "_y1", "_z1", "_x2", "_y2"];
	private _xSize = _x2 - _x1;
	private _ySize = _y2 - _y1;
	if (_boundingBoxMode == 0) then {
		_boundingBoxMode = [BB_CORNER, BB_EDGEMIDPOINT] select (_xSize < 1 || {_ySize < 1});
	};
	switch (_boundingBoxMode) do {
	    case (BB_EDGEMIDPOINT): {
			systemChat "auto midpoint";
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
			systemChat "auto corner";
			[
 	   			[_x1, _y1, _z1],
 	   			[_x1, _y2, _z1],
 	   			[_x2, _y1, _z1],
 	   			[_x2, _y2, _z1]
 	   		]
		};
	};
}, true]
