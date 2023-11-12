class CfgUserActions {
    class GVAR(snapSelectedToCursor) { // This class name is used for internal representation and also for the inputAction command.
        displayName = CSTRING(KeySnapToCursor);
        tooltip = CSTRING(KeySnapToCursor_Tooltip);
        onActivate = QUOTE([] call FUNC(snapSelectedToCursor));		// _this is always true.
    };
    class GVAR(toggleSnapping) { // This class name is used for internal representation and also for the inputAction command.
        displayName = CSTRING(SnappingToggle);
        tooltip = CSTRING(SnappingToggle_Tooltip);
        onActivate = QUOTE([KEY_SNAPPING] call FUNC(handleInputToggle));		// _this is always true.
    };
    class GVAR(toggleRotation) { // This class name is used for internal representation and also for the inputAction command.
        displayName = CSTRING(RotationToggle);
        tooltip = CSTRING(RotationToggle_Tooltip);
        onActivate = QUOTE([KEY_ROTATION] call FUNC(handleInputToggle));		// _this is always true.
    };
    class GVAR(toggleTerrain) { // This class name is used for internal representation and also for the inputAction command.
        displayName = CSTRING(TerrainToggle);
        tooltip = CSTRING(RotationToggle_Tooltip);
        onActivate = QUOTE([KEY_TERRAIN] call FUNC(handleInputToggle));		// _this is always true.
    };
    class GVAR(OpenAttributes) { // This class name is used for internal representation and also for the inputAction command.
        displayName = "$STR_3DEN_Display3DEN_ControlsHint_Attributes";
        tooltip = CSTRING(KeyOpenAttributes_Tooltip);
        onActivate = "if (is3DEN) then {do3DENAction 'OpenAttributes';};";		// _this is always true.
    };
};
