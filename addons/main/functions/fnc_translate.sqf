#include "script_component.hpp"
/*
 * Author: Ampersand
 * Set the posASL for the object in Eden or Zeus.
 *
 * Arguments:
 * 0: Object <OBJECT>
 * 1: Translation Offset <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_object, _translation] call sez_main_fnc_translate
 *
 * Public: No
 */

params ["_object", "_translation"];

if (is3DEN) then {
    private _pos = (_object get3DENAttribute "position") select 0;
    _object set3DENAttribute ["position", _pos vectorDiff _translation];
} else {
    private _pos = getPosWorld _object vectorDiff _translation;
    _object setPosWorld _pos;
};
