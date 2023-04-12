#include "script_component.hpp"
/*
 * Author: Ampersand
 * Set the posASL for the object in Eden or Zeus.
 *
 * Arguments:
 * 0: Object <OBJECT>
 * 1: Position ASL <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_object, _posASL] call sez_main_fnc_setPosASL
 *
 * Public: No
 */

params ["_object", "_posASL"];

if (is3DEN) then {
    _object set3DENAttribute ["position", ASLToATL _posASL];
} else {
    _object setPosASL _posASL;
};
