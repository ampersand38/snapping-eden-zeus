#include "script_component.hpp"
/*
* Author: Ampersand
* Toggle angle snapping on curator time input
*
* Arguments:
* 0: Points <ARRAY> [[[x,y,z], [r,g,b,a]], ]
*
* Return Value:
* None
*
* Example:
* [[_point, _colour]] call sez_main_fnc_drawHint
*
* Public: No
*/

if (isNil "snap_hint_ids") then {
    snap_hint_ids = [];
} else {
    {
        removeMissionEventHandler ["Draw3D", _x # 0];
    } forEach snap_hint_ids;
    snap_hint_ids = [];
};

private _id = addMissionEventHandler ["Draw3D",{
    if (time > snap_hint_time) exitWith {
        removeMissionEventHandler [_thisEvent, _thisEventHandler];
    };
    {
        drawIcon3D [
            "a3\ui_f\data\Map\MarkerBrushes\cross_ca.paa",
            _x select 1,
            _x select 0,
            1,1,0,""
        ];
    } forEach (snap_hint_ids select (snap_hint_ids find _thisEventHandler) select 1);
}];

snap_hint_ids pushBack [_id, _this];
snap_hint_time = time + 3;
