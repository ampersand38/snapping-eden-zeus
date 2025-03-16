/*
call compile preProcessFileLineNumbers "z\sez\addons\main\snap_points\findCornerAtCenter.sqf"
*/
sez_fnc_getSelected = {get3DENSelected "object" param [0, objNull]};

sez_fnc_intersect3Planes = {
    params ["_p1", "_p2", "_p3", "_v1", "_v2", "_v3"];
    (
        ((_v2 vectorCrossProduct _v3) vectorMultiply (_p1 vectorDotProduct _v1))
        vectorAdd ((_v3 vectorCrossProduct _v1) vectorMultiply (_p2 vectorDotProduct _v2))
        vectorAdd ((_v1 vectorCrossProduct _v2) vectorMultiply (_p3 vectorDotProduct _v3))
    ) vectorMultiply (1/(_v1 vectorDotProduct (_v2 vectorCrossProduct _v3)))
};

sez_fnc_findCornerAtCenter = {
    params [
        ["_maxRadius", 2],
        ["_lod", "FIRE"]
    ];

    _icon = "a3\ui_f\data\Map\MarkerBrushes\cross_ca.paa";
    _colours = [
        [1, 0, 0, 1],
        [0, 1, 0, 1],
        [0, 0, 1, 1]
    ];

    scopeName "main";

    private _object = call sez_fnc_getSelected;
    private _points = [];
    private _normals = [];

    // Scan in circles around line of sight, increasing radius and samples per revolution
    private _camPos = AGLToASL positionCameraToWorld [0, 0, 0];
    for "_r" from 0 to _maxRadius do { // radius
        private _radius = _r * 2;
        private _countAngles = 1 max (4 ^ _r); // 1, 4, 16
        for "_a" from 0 to _countAngles do { // angle
            private _angle = _a * 360 / _countAngles;
            private _pc2w = [0, 0, 100] getPos [_radius, _angle]; // [0,0,100], [1,0,100], [0,1,100], [-1,0,100], [0,-1,100],
            _pc2w set [2, 100];
//systemChat str ["_r", _r, " _a", _a, " _pc2w", _pc2w];

            private _in = lineIntersectsSurfaces [
                _camPos, AGLToASL positionCameraToWorld _pc2w,
                objNull, objNull, true, 1, _lod, "NONE"
            ] param [0, []];
            if (_in isEqualTo []) then {continue;};

            _in params ["_posASL", "_vNormal", "_intersectObject", "_parentObject"];
            if (isNull _intersectObject) then {continue;};

drawIcon3D [_icon, [1, 1, 1, 0.35], ASLToAGL _posASL, 1, 1, 0, ""];

            if (isNull _object) then {
                _object = _intersectObject;
            };

            private _isNewPlane = _normals pushBackUnique _vNormal;
            if (_isNewPlane == -1) then {
                //systemChat "same normal";
                continue;
            };

            _points pushBackUnique _posASL;
            if (count _normals == 3) then {
                //systemChat str (count (_points + _normals));
                breakTo "main";
            };
        };
    };

    //systemChat str ["_points", _points, "_normals", _normals];
    _points = _points apply {ASLToAGL _x};

    {
        //drawIcon3D [_icon, _colours select _forEachIndex, _x, 1, 1, 0, ""];
    } forEach _points;
    {
        _pt = _points select _forEachIndex;
        drawLine3D [_pt, _x vectorAdd _pt, _colours select _forEachIndex];
    } forEach _normals;

    if (count _normals < 3) exitWith {[]};

    private _pos3Planes = (_points + _normals) call sez_fnc_intersect3Planes;
    drawIcon3D [_icon, [1, 0, 1, 1], _pos3Planes, 1, 1, 0, ""];
    _pos3Planes = (_object worldToModelVisual _pos3Planes);

    private _name = typeOf _object;
    if (_name == "") then {
        _name = str _object;
    };

    [_object, _pos3Planes]
};

if (isNil "sez_ids") then {sez_ids = [];} else {{removeMissionEventHandler _x;} forEach sez_ids;sez_ids = [];};
sez_ids pushBack ["Draw3D", addMissionEventHandler ["Draw3D", {
    sez_corner = [] call sez_fnc_findCornerAtCenter;
}]];

add3DENEventHandler ["OnCut",{{removeMissionEventHandler _x;} forEach sez_ids;sez_ids = [];}];
