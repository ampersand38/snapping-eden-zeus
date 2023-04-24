/*
In editor, run entire script in Debug Console.
Add Watch fields:
    [sez_points, sez_normals]
    _v=call sez_fnc_getVehicle; [typeOf _v, if (count sez_points == 3) then { [(sez_points + sez_normals) call sez_fnc_intersect3Planes]}]
Select an object and Cut (Ctrl + X) to initiate or reset.
Select the object for which you need to find a vertex position.
For each of 3 intersecting planes,
    Point camera at it using the normal line being drawn
    Copy (Ctrl + C) to log the plane
Once you have 3 entries, the watch field will show the object model coordinates of
the point of intersection

Test the points by updating the snap points of an object class like so:

snapPointsMap set [typeOf _obj, [_pt1, _pt2,...]];
*/

sez_fnc_getVehicle = {get3DENSelected "object" # 0};

sez_fnc_intersect3Planes = {
    params ["_p1", "_p2", "_p3", "_v1", "_v2", "_v3"];
    (
        ((_v2 vectorCrossProduct _v3) vectorMultiply (_p1 vectorDotProduct _v1))
        vectorAdd ((_v3 vectorCrossProduct _v1) vectorMultiply (_p2 vectorDotProduct _v2))
        vectorAdd ((_v1 vectorCrossProduct _v2) vectorMultiply (_p3 vectorDotProduct _v3))
    ) vectorMultiply (1/(_v1 vectorDotProduct (_v2 vectorCrossProduct _v3)))
};

sez_fnc_onCut = {
    sez_points = [];
    sez_normals = [];
    sez_intersection = [];

    if (is3DEN && {current3DENOperation != ""}) exitWith {};

    if (isNil "sez_ids") then {sez_ids = [];} else { {removeMissionEventHandler ["EachFrame", _x];} forEach sez_ids };
    sez_ids pushBack addMissionEventHandler ["EachFrame",{
    	private _v = 0 call sez_fnc_getVehicle;
    	private _in = lineIntersectsSurfaces [
            AGLToASL positionCameraToWorld [0,0,0],
    		AGLToASL positionCameraToWorld [0,0,100],
    		objNull, objNull, true, 1, "GEOM", "NONE"
    	] param [0, []];
    	if (_in  isEqualTo []) exitWith {};

        sez_intersection = _in;
    	_in params ["_posASL", "_vn", "_intersectObject", "_parentObject"];
        private _pos = ASLToAGL _posASL;
        sez_point = (_v worldToModel _pos);
        sez_normal = (_v vectorworldToModel _vn);
    	drawLine3D [
            _pos,
            _pos vectorAdd _vn,
    		[1,0,0,1]
        ];

        {
            drawIcon3D [
            	"a3\ui_f\data\Map\MarkerBrushes\cross_ca.paa",
            	[1,0,0,1],
            	_v modelToWorld _x,
            	1,1,0,str _x
            ];
        } forEach ( [_v] call sez_main_fnc_getSnapPoints);
    }];
};
add3DENEventHandler ["OnCut",{call sez_fnc_onCut}];

sez_fnc_onCopy = {
        if (is3DEN && {current3DENOperation != ""}) exitWith {};
        sez_points pushBackUnique sez_point;
        sez_normals pushBackUnique sez_normal;
        if (count sez_points == 3) then {
            sez_intersection = (sez_points + sez_normals) call sez_fnc_intersect3Planes;
            copyToClipboard str sez_intersection;
            systemChat str sez_intersection;
        } else {
            systemChat str count sez_points;
        };
};
add3DENEventHandler ["OnCopy",{call sez_fnc_onCopy}];
