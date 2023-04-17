class CfgUserActions {
    class GVAR(toggleSnapping) { // This class name is used for internal representation and also for the inputAction command.
        displayName = "Snapping Toggle";
        tooltip = "";
        onActivate = QUOTE([KEY_SNAPPING] call FUNC(handleInputToggle));		// _this is always true.
    };
    class GVAR(toggleRotation) { // This class name is used for internal representation and also for the inputAction command.
        displayName = "Rotation Toggle";
        tooltip = "";
        onActivate = QUOTE([KEY_ROTATION] call FUNC(handleInputToggle));		// _this is always true.
    };
    class GVAR(toggleTerrain) { // This class name is used for internal representation and also for the inputAction command.
        displayName = "Terrain Toggle";
        tooltip = "";
        onActivate = QUOTE([KEY_TERRAIN] call FUNC(handleInputToggle));		// _this is always true.
    };
};
