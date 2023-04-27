#include "script_component.hpp"
/*
 * Author: Ampersand
 * Returns the nearest pair of points from the given 2 lists.
 *
 * Arguments:
 * 0: List 1 <ARRAY> of points
 * 1: List 2 <ARRAY> of points
 *
 * Return Value:
 * 0: List 1 point
 * 1: List 2 point
 * 2: Nearest distance <NUMBER>
 *
 * Example:
 * [[_p1, _p2], [_p3, _p4]] call sez_main_fnc_nearestPair
 *
 * Public: No
 */

params ["_list1", "_list2", ["_minDistance", 1000], ["_index1", 0], ["_index2", 0], ["_minDistance_2", 1000], ["_index1_2", 0], ["_index2_2", 0]];

{
	private _p1 = _x;
	private _i1 = _forEachIndex;
	{
		private _d = _p1 distance _x;
		if (_d >= _minDistance) then {continue;};

		_minDistance_2 = _minDistance;
		_index1_2 = _index1;
		_index2_2 = _index2;
        //systemChat str ["pair", _d, _index1_2, _index2_2];
		_minDistance = _d;
		_index1 = _i1;
		_index2 = _forEachIndex;
	} forEach _list2;
} forEach _list1;

[
    _minDistance, _list1 # _index1, _list2 # _index2,
    _minDistance_2, _list1 # _index1_2, _list2 # _index2_2
]
