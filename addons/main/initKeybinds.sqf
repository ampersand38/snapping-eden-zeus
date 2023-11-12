[
    LSTRING(SnappingforEdenandZeus), "sez_toggleSnapping",
    [LSTRING(SnappingToggle), LSTRING(SnappingToggle_Tooltip)],
    {
        if (!sez_setting_useKeybinds) exitWith {};

        sez_snappingenabled = !sez_snappingenabled;

        private _text = format ["%1 %2",LSTRING(HintSnapping), ["disabled", "enabled"] select sez_snappingenabled];

        if (is3DEN) exitWith {
            [_text, parseNumber (!sez_snappingenabled), 3, false] call BIS_fnc_3DENNotification
        };

        //if (!isNull curatorCamera) exitWith {}
        [LSTRING(HintSnapping), _text, 3] call BIS_fnc_curatorHint;
    }, {}
] call CBA_fnc_addKeybind;

[
    LSTRING(SnappingforEdenandZeus), "sez_toggleSnapping",
    [LSTRING(RotationToggle), LSTRING(RotationToggle_Tooltip)],
    {
        if (!sez_snappingEnabled) exitWith {};

        sez_rotationenabled = !sez_rotationenabled;

        private _text = format ["%1 %2", localize "str_a3_cfgvehicles_modulepositioning_f_arguments_rotation_0", ["disabled", "enabled"] select sez_rotationenabled];

        if (is3DEN) exitWith {
            [_text, parseNumber (!sez_rotationenabled), 3, false] call BIS_fnc_3DENNotification
        };

        //if (!isNull curatorCamera) exitWith {}
        [LSTRING(HintSnapping), _text, 3] call BIS_fnc_curatorHint;
    }, {}
] call CBA_fnc_addKeybind;

[
    LSTRING(SnappingforEdenandZeus), "sez_toggleSnapping",
    [LSTRING(TerrainToggle), LSTRING(TerrainToggle_Tooltip)],
    {
        if (!sez_snappingEnabled) exitWith {};

        sez_terrainenabled = !sez_terrainenabled;

        private _text = format ["%1 %2", localize "STR_3DEN_Display3DENSave_Filter_Terrain_text", ["disabled", "enabled"] select sez_terrainenabled];

        if (is3DEN) exitWith {
            [_text, parseNumber (!sez_terrainenabled), 3, false] call BIS_fnc_3DENNotification
        };

        //if (!isNull curatorCamera) exitWith {}
        [LSTRING(HintSnapping), _text, 3] call BIS_fnc_curatorHint;
    }, {}
] call CBA_fnc_addKeybind;
