/*
// Run:
call compile preProcessFileLineNumbers "z\sez\addons\main\snap_points\findCornerAtMouse.inc.sqf"
// Watch:
[toLower getText (configOf sez_object >> "model"),[sez_corner]]
*/

sez_fnc_resetEH = {
    if (isNil "sez_ids") then {sez_ids = [];} else {
        {
            (_x # 0) call (_x # 1);
        } forEach sez_ids;
    };
    sez_ids = [];
};
[] call sez_fnc_resetEH;

sez_fnc_vectorMean = {
    _v = [0,0,0];
    {
        _v = _v vectorAdd _x;
    } forEach _this;
    _r = _v vectorMultiply (1/count _this);
    copyToClipboard str _r;
    _r
};

sez_fnc_getSelected = {get3DENSelected "object" param [0, objNull]};

sez_fnc_intersect3Planes = {
    params ["_p1", "_p2", "_p3", "_v1", "_v2", "_v3"];
    (
        ((_v2 vectorCrossProduct _v3) vectorMultiply (_p1 vectorDotProduct _v1))
        vectorAdd ((_v3 vectorCrossProduct _v1) vectorMultiply (_p2 vectorDotProduct _v2))
        vectorAdd ((_v1 vectorCrossProduct _v2) vectorMultiply (_p3 vectorDotProduct _v3))
    ) vectorMultiply (1/(_v1 vectorDotProduct (_v2 vectorCrossProduct _v3)))
};

sez_fnc_findCornerAtMouse = {
    params [
        ["_maxRadius", 2],
        ["_lod", "GEOM"]
    ];

    sez_point = [];
    sez_normal = [];
    _icon = "a3\ui_f\data\Map\MarkerBrushes\cross_ca.paa";
    _colours = [
        [1, 0, 0, 1],
        [0, 1, 0, 1],
        [0, 0, 1, 1],
        [1, 0, 1, 1]
    ];

    // Draw hints
    if (sez_corner isNotEqualTo []) then {
        drawIcon3D [_icon, [1, 0, 1, 1], sez_pos3Planes, 1, 1, 0, ""];
    };
    {
        //drawIcon3D [_icon, _colours select _forEachIndex, _x, 1, 1, 0, ""];
    } forEach sez_points;
    {
        _pt = sez_points select _forEachIndex;
        drawLine3D [_pt, _x vectorAdd _pt, _colours select _forEachIndex];
    } forEach sez_normals;

    //if (count sez_points < 3) then {
        private _camPos = AGLToASL positionCameraToWorld [0, 0, 0];
        private _camPos2 = AGLToASL positionCameraToWorld [0, 0, 1000];
        private _mousePos = AGLToASL screenToWorld getMousePosition;
        private _pos2 = if (_camPos2 # 2 > _camPos # 2) then {_mousePos} else {_camPos2};
        private _in = lineIntersectsSurfaces [
            _camPos, _camPos2,
            objNull, objNull, true, 1, _lod, "VIEW"
        ] param [0, []];
        if (_in isEqualTo []) exitWith {};

        _in params ["_posASL", "_vNormal", "_intersectObject", "_parentObject"];
        if (isNull _intersectObject) exitWith {};

        if (isNull sez_object) then {
            sez_object = _intersectObject;
        };

        if (_vNormal in sez_normals) exitWith {};

        sez_point = ASLToAGL _posASL;
        sez_normal = _vNormal;

        drawLine3D [sez_point, sez_point vectorAdd _vNormal, [1,1,1,0.3]];
    //};

};

sez_ids pushBack [["OnCopy", add3DENEventHandler ["OnCopy",{

    sez_object = objNull;
    sez_pos3Planes = [];
    sez_corner = [];
    sez_points = [];
    sez_normals = [];
    //[] call sez_fnc_resetEH;
    sez_ids pushBack [["Draw3D", addMissionEventHandler ["Draw3D", {
        [] call sez_fnc_findCornerAtMouse;
    }]], {removeMissionEventHandler _this}];

}]], {remove3DENEventHandler _this}];

sez_ids pushBack [["OnCopy", add3DENEventHandler ["OnCut",{
    [] call sez_fnc_resetEH;
}]], {remove3DENEventHandler _this}];

sez_fnc_add = {
    params ["_index"];

    if (sez_point isNotEqualTo []) then {
        sez_points set [_index, sez_point];
        sez_normals set [_index, sez_normal];
    };
    if (count sez_points == 3) then {
        sez_pos3Planes = (sez_points + sez_normals) call sez_fnc_intersect3Planes;
        sez_corner = (sez_object worldToModelVisual sez_pos3Planes);

        if (toLower typeOf sez_object in sez_snapPointsMap
            || {toLower getText (configOf sez_object >> "model") in sez_snapPointsMap}
        ) then {
            copyToClipboard str sez_corner;
        } else {
            //copyToClipboard str [toLower typeOf sez_object,[sez_corner]];
            copyToClipboard str [toLower getText (configOf sez_object >> "model"),[sez_corner]];
        };
    };

};

sez_ids pushBack [["OnWidgetNone", add3DENEventHandler ["OnWidgetNone",{
    [0] call sez_fnc_add;
}]], {remove3DENEventHandler _this}];

sez_ids pushBack [["OnWidgetTranslation", add3DENEventHandler ["OnWidgetTranslation",{
    [1] call sez_fnc_add;
}]], {remove3DENEventHandler _this}];

sez_ids pushBack [["OnWidgetRotation", add3DENEventHandler ["OnWidgetRotation",{
    [2] call sez_fnc_add;
}]], {remove3DENEventHandler _this}];
