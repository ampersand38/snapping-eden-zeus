class UserActionsConflictGroups {
    class ActionGroups {
        GVAR(ActionGroup)[] = {
            QGVAR(toggleSnapping),
            QGVAR(toggleRotation),
            QGVAR(toggleTerrain),
            QGVAR(OpenAttributes)
        };
    };

    class CollisionGroups {
        // Add your group to an existing collision group:
        //carMove[] += {"TAG_MyActionGroup"};

        // Or alternatively add your own collision group (which is usually preferrable):
        GVAR(ActionGroupCollisions)[] = {"curator", QGVAR(ActionGroup)};
    };
};
