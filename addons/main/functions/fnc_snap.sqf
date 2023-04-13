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
	["_angle", 90],
	["_boundingBoxMode", BB_EDGEMIDPOINT]
];

//systemChat str _this;
// If there is another cargo platform nearby then try to snap to it
// First we have to wait till dragging is completed
if (is3DEN && {current3DENOperation != "" || {get3DENActionState "MoveGridToggle" == 0}}) exitWith {};

if !(_object isKindOf "Static") exitWith {};

private _snapPointsThis = [_object] call FUNC(getSnapPoints);
if (_snapPointsThis isEqualTo []) exitWith {};
_snapPointsThis = _snapPointsThis apply {_object modelToWorldVisual _x};

private _nearbyObjects = if (_snapTo isEqualType []) then {
    nearestObjects [_object, _snapTo, 50 max (((boundingBox _object) # 2) * 2.5)] - [_object];
} else {
    [_snapTo]
};

if (_nearbyObjects isEqualTo []) exitWith {
    systemChat "no neighbours";
};

private _minDistance = 1000;
private _neighbour = objNull;
private _snapPointThis = [];
private _snapPointNeighbour = [];
{
    private _xObject = _x;
    private _xSnapPoints = [_xObject] call FUNC(getSnapPoints) apply {_xObject modelToWorldVisual _x};

    [_snapPointsThis, _xSnapPoints] call FUNC(nearestPair) params ["_snapPointObject", "_xSnapPoint", "_xDistance"];
    _minDistance = _minDistance min _xDistance;

    if (_xDistance < 1) then {
        _neighbour = _xObject;
        _snapPointNeighbour = _xSnapPoint;
        _snapPointThis = _snapPointObject;
        break;
    };
} forEach _nearbyObjects;

if (isNull _neighbour) exitWith { systemChat format ["closest snap point %1", _minDistance]};

private _pos = getposASL _object;

if (_angle > -1
	&& {
		(is3DEN && {get3DENActionState "RotateGridToggle" == 1})
		|| {!isNull curatorCamera && {shownCuratorCompass}}
	}) then {
	// Reconvert to model space due to dir change
	_posModel = _object worldToModel _snapPointThis;

	// Adjust direction
	_dirTo		= getDir _neighbour - 360;
	_dirObject	= getDir _object;
	_dir		= _dirTo;

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
        (is3DEN && {get3DENActionState "SurfaceSnapToggle" == 1})
        || {!isNull curatorCamera}
    }
) then {
	private _height = getPos _object # 2;
	_pos = _pos vectorAdd [0, 0, -_height];
	[_object, _pos] call FUNC(setPosASL);
};

if (isNil "snap_hint_ids") then {snap_hint_ids = [];} else { {removeMissionEventHandler ["Draw3D", _x # 0];} forEach snap_hint_ids; snap_hint_ids = []; };
private _id = addMissionEventHandler ["Draw3D",{
	if (time > snap_hint_time) exitWith {removeMissionEventHandler [_thisEvent, _thisEventHandler];};
	{
		drawIcon3D [
			"a3\ui_f\data\Map\MarkerBrushes\cross_ca.paa",
			[1,_forEachIndex,0,1],
			_x,
			1,1,0,""
		];
	} forEach (snap_hint_ids select (snap_hint_ids find _thisEventHandler) select 1);
}];
snap_hint_ids pushBack [_id, [_snapPointNeighbour, _snapPointThis]];
snap_hint_time = time + 3;
//systemChat format["nearby objects %1 %2 snap point %3",_neighbour,_object distance _neighbour,_snapPointsThis];
