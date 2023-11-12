class UserActionGroups
{
	class GVAR(Snapping) // Unique classname of your category.
	{
		name = CSTRING(SnappingforEdenandZeus); // Display name of your category.
		isAddon = 1;
		group[] = { // List of all actions inside this category.
            QGVAR(snapSelectedToCursor),
            QGVAR(toggleSnapping),
            QGVAR(toggleRotation),
            QGVAR(toggleTerrain),
            QGVAR(OpenAttributes)
        };
	};
};
