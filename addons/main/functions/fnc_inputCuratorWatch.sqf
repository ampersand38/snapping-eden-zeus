#include "script_component.hpp"
/*
 * Author: Ampersand
 * Toggle angle snapping on curator time input
 *
 * Arguments:
 * None
 * Return Value:
 * None
 *
 * Example:
 * 0 call sez_main_fnc_inputCuratorWatch
 *
 * Public: No
 */

if (isNull curatorCamera || {!shownCuratorCompass}) exitWith {};
sez_curatorSnapAngleEnabled = !sez_curatorSnapAngleEnabled;

["Snapping",
"Angle snapping " + (["disabled", "enabled"] select sez_curatorSnapAngleEnabled),
3] call BIS_fnc_curatorHint;
