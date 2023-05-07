class CfgUserActions {
    class GVAR(snapSelectedToCursor) { // This class name is used for internal representation and also for the inputAction command.
        displayName = "Snap to Cursor";
        tooltip = "Snap selected object to the object under the cursor";
        onActivate = QUOTE([] call FUNC(snapSelectedToCursor));		// _this is always true.
    };
    class GVAR(toggleSnapping) { // This class name is used for internal representation and also for the inputAction command.
        displayName = "Snapping Toggle";
        tooltip = "Toggle snapping on drag-and-drop";
        onActivate = QUOTE([KEY_SNAPPING] call FUNC(handleInputToggle));		// _this is always true.
    };
    class GVAR(toggleRotation) { // This class name is used for internal representation and also for the inputAction command.
        displayName = "Rotation Toggle";
        tooltip = "Toggle rotation snapping on drag-and-drop";
        onActivate = QUOTE([KEY_ROTATION] call FUNC(handleInputToggle));		// _this is always true.
    };
    class GVAR(toggleTerrain) { // This class name is used for internal representation and also for the inputAction command.
        displayName = "Terrain Toggle";
        tooltip = "Toggle terrain snapping on drag-and-drop";
        onActivate = QUOTE([KEY_TERRAIN] call FUNC(handleInputToggle));		// _this is always true.
    };
    class GVAR(OpenAttributes) { // This class name is used for internal representation and also for the inputAction command.
        displayName = "Open Attributes";
        tooltip = "Open Eden Attributes diagloue for the selected entities";
        onActivate = "if (is3DEN) then {do3DENAction 'OpenAttributes';};";		// _this is always true.
    };
};
