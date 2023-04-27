/*
call compile preProcessFileLineNumbers "z\sez\addons\main\snap_points\models.sqf"
*/

private _models = [
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_c.p3d",
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_c2.p3d",
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_c2_end.p3d",
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_c_270.p3d",
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_c_90.p3d",
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_c_big.p3d",
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_C_L.p3d",
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_C_L10.p3d",
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_C_L30.p3d",
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_C_R.p3d",
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_C_R10.p3d",
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_C_R30.p3d",
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_c_t15.p3d",
"P:\a2\Structures\CA\Structures\Nav_Pier\nav_pier_c_t20.p3d"
];

_models apply {
    _m = createSimpleObject [_x, [0,0,0]];
    _s = (_m selectionNames 1e15) select {"snap_" in _x} apply {_m selectionPosition [_x, 1e15]};
    deleteVehicle _m;
    [_x, _s]
} joinString ("," + endl);
