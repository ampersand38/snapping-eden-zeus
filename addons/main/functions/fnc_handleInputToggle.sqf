#include "script_component.hpp"
/*
 * Author: Ampersand
 * Handle keybind.
 *
 * Arguments:
 * 0: Mode <NUMBER>
 *     #define KEY_SNAPPING 0
 *     #define KEY_ROTATION 1
 *     #define KEY_TERRAIN 2
 *
 * Return Value:
 * None
 *
 * Example:
 * [0] call sez_main_fnc_handleInputToggle
 *
 * Public: No
 */

params ["_mode"];

if (!sez_setting_useKeybinds) exitWith {};
if (!sez_snappingEnabled && {_mode > 0}) exitWith {};

private _varName = [
    "sez_snappingEnabled",
    "sez_rotationEnabled",
    "sez_terrainEnabled"
] select _mode;

private _modeName = [
    "Snapping",
    "Rotation",
    "Terrain"
] select _mode;

private _value = !(missionNamespace getVariable [_varName, false]);
missionNamespace setVariable [_varName, _value];

private _text = format ["%1 %2", _modeName, ["disabled", "enabled"] select _value];

if (is3DEN) exitWith {
    [_text, parseNumber (!_value), 3, false] call BIS_fnc_3DENNotification;
};

//if (!isNull curatorCamera) exitWith {}
["Snapping", _text, 3] call BIS_fnc_curatorHint;
