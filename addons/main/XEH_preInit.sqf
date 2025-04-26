#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

sez_snappingenabled = false;
sez_rotationenabled = false;
sez_terrainenabled = false;

#include "initSettings.inc.sqf"
#include "initSnapping.inc.sqf"

sez_curatorSnapAngleEnabled = true;

["ModuleCurator_F", "Init", {
    params ["_logic"];

    _logic addEventHandler ["CuratorObjectEdited", {if (sez_setting_useKeybinds) exitWith {}; [_this select 1] call FUNC(snap)}];
    _logic addEventHandler ["CuratorObjectPlaced", {if (sez_setting_useKeybinds) exitWith {}; [_this select 1] call FUNC(snap)}];
}, true, [], true] call CBA_fnc_addClassEventHandler;

ADDON = true;
