// COMPONENT should be defined in the script_component.hpp and included BEFORE this hpp

#define MAINPREFIX z
#define PREFIX sez

#include "script_version.hpp"

#define VERSION MAJOR.MINOR
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD
#define VERSION_CONFIG version = VERSION; versionStr = QUOTE(MAJOR.MINOR.PATCHLVL-BUILD); versionAr[] = {VERSION_AR}

#define SEZ_TAG SEZ

// MINIMAL required version for the Mod. Components can specify others..
#define REQUIRED_VERSION 1.56

#ifdef COMPONENT_BEAUTIFIED
    #define COMPONENT_NAME QUOTE(sez - COMPONENT_BEAUTIFIED)
#else
    #define COMPONENT_NAME QUOTE(sez - COMPONENT)
#endif
