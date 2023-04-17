class UserActionGroups
{
	class GVAR(Snapping) // Unique classname of your category.
	{
		name = "Snapping for Eden and Zeus"; // Display name of your category.
		isAddon = 1;
		group[] = { // List of all actions inside this category.
            QGVAR(toggleSnapping),
            QGVAR(toggleRotation),
            QGVAR(toggleTerrain),
            QGVAR(OpenAttributes)
        };
	};
};
