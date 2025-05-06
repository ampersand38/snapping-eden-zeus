#include "script_component.hpp"
/*
* Author: Ampersand
* Opens the 3DEN Attributes dialog for the selected object.
*
* Arguments:
* None
*
* Return Value:
* None
*
* Example:
* [] call sez_main_fnc_openAttributes
*
* Public: No
*/

#include "exitIfTyping.inc.sqf"

if (is3DEN) then {do3DENAction "OpenAttributes";};
