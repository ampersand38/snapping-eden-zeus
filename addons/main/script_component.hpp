#define COMPONENT main
#include "\z\sez\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define CBA_DEBUG_SYNCHRONOUS
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_MAIN
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_MAIN
    #define DEBUG_SETTINGS DEBUG_SETTINGS_MAIN
#endif

#include "\z\sez\addons\main\script_macros.hpp"

#define KEY_SNAPPING 0
#define KEY_ROTATION 1
#define KEY_TERRAIN 2
