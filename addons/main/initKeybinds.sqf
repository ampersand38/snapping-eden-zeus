[
    "Snapping for Eden and Zeus", "sez_toggleSnapping", "Snapping Toggle",{
        sez_snappingenabled = !sez_snappingenabled;

        private _text = format ["Snapping %1", ["disabled", "enabled"] select sez_snappingenabled];

        if (is3DEN) exitWith {
            [_text, parseNumber (!sez_snappingenabled), 3, false] call BIS_fnc_3DENNotification
        };

        //if (!isNull curatorCamera) exitWith {}
        ["Snapping", _text, 3] call BIS_fnc_curatorHint;
    }, {}
] call CBA_fnc_addKeybind;

[
    "Snapping for Eden and Zeus", "sez_toggleRotation", "Rotation Toggle",{
        if (!sez_snappingenabled) exitWith {};

        sez_rotationenabled = !sez_rotationenabled;

        private _text = format ["Rotation %1", ["disabled", "enabled"] select sez_rotationenabled];

        if (is3DEN) exitWith {
            [_text, parseNumber (!sez_rotationenabled), 3, false] call BIS_fnc_3DENNotification
        };

        //if (!isNull curatorCamera) exitWith {}
        ["Snapping", _text, 3] call BIS_fnc_curatorHint;
    }, {}
] call CBA_fnc_addKeybind;

[
    "Snapping for Eden and Zeus", "sez_toggleTerrain", "Terrain Toggle",{
        if (!sez_snappingenabled) exitWith {};

        sez_terrainenabled = !sez_terrainenabled;

        private _text = format ["Terrain %1", ["disabled", "enabled"] select sez_terrainenabled];

        if (is3DEN) exitWith {
            [_text, parseNumber (!sez_terrainenabled), 3, false] call BIS_fnc_3DENNotification
        };

        //if (!isNull curatorCamera) exitWith {}
        ["Snapping", _text, 3] call BIS_fnc_curatorHint;
    }, {}
] call CBA_fnc_addKeybind;
