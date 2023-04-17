// watch
//[points, normals apply {_x apply {round _x}}]

add3DENEventHandler ["OnCut",{
    if (is3DEN && {current3DENOperation != ""}) exitWith {};

if (isNil "amp_ids") then {amp_ids = [];} else { {removeMissionEventHandler ["EachFrame", _x];} forEach amp_ids };
amp_ids pushBack addMissionEventHandler ["EachFrame",{
	private _v = call amp_fnc_gv;
	private _in = lineIntersectsSurfaces [
	AGLToASL	positionCameraToWorld [0,0,0],
		AGLToASL	positionCameraToWorld [0,0,100],

		objNull, objNull, true, 1, "GEOM", "NONE"
	] param [0, []];
	if (_in  isEqualTo []) exitWith {};

	_in params ["_posASL", "_vn"];
private _pos = ASLToAGL _posASL;
point = (_v worldToModel _pos);
normal = (_v vectorworldToModel _vn);
		drawLine3D [
_pos,
_pos vectorAdd _vn,
		[1,0,0,1]];

{
drawIcon3D [
	"a3\ui_f\data\Map\MarkerBrushes\cross_ca.paa",
	[1,0,0,1],
	_v modelToWorld _x,
	1,1,0,str _x
];
}		forEach ( [_v] call sez_main_fnc_getSnapPoints);

}];
points = [];
normals =  [];
}];

add3DENEventHandler ["OnCopy",{
    if (is3DEN && {current3DENOperation != ""}) exitWith {};
    points pushBackUnique point;
    normals pushBackUnique normal;
}];
