#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main"};
        author = "Ampersand";
        authors[] = {"Ampersand"};
        authorUrl = "https://github.com/ampersand38/snapping-eden-zeus";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"

#include "config\CfgDefaultKeysPresets.hpp"
#include "config\CfgUserActions.hpp"
#include "config\UserActionGroups.hpp"
#include "config\UserActionsConflictGroups.hpp"
