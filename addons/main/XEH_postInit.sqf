#include "script_component.hpp"

if (hasInterface) then {
    addUserActionEventHandler ["CuratorWatch", "Activate", {0 call FUNC(inputCuratorWatch)}];
};
