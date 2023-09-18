#include "script_component.hpp"
/*
 * Author: Ampersand
 * Returns the nearest pair of points from the given 2 lists.
 *
 * Arguments:
 * 0: List A <ARRAY> of points
 * 1: List B <ARRAY> of points
 *
 * Return Value:
 * 0: Nearest distance <NUMBER>
 * 1: List A point <ARRAY>
 * 2: List B point <ARRAY>
 * 3: Second nearest distance <NUMBER>
 * 4: Second List A point <ARRAY>
 * 5: Second List B point <ARRAY>
 *
 * Example:
 * [[_p1, _p2], [_p3, _p4]] call sez_main_fnc_nearestPair
 * [[_p1, _p2], [_p3, _p4]] call sez_main_fnc_nearestPair params ["", "_pt1", "_pt2"];
 *
 * Public: No
 */

params [
    "_listA", "_listB",
    // private variables
    ["_minDistance", 1000], ["_indexA", 0], ["_indexB", 0],
    ["_minDistance_2", 1000], ["_indexA_2", 0], ["_indexB_2", 0]
];

{
    private _xPointA = _x;
    private _xIndexA = _forEachIndex;
    {
        private _xDistance = _xPointA distance _x;
        if (_xDistance < _minDistance) then {
            _minDistance_2 = _minDistance;
            _indexA_2 = _indexA;
            _indexB_2 = _indexB;
            _minDistance = _xDistance;
            _indexA = _xIndexA;
            _indexB = _forEachIndex; // _xIndexB
            continue;
        };

        if (_xDistance < _minDistance_2) then {
            _minDistance_2 = _xDistance;
            _indexA_2 = _xIndexA;
            _indexB_2 = _forEachIndex;
        };
    } forEach _listB;
} forEach _listA;

if false exitWith {
    [
        0, _listA # 0, _listB # 0,
        0, _listA # 1, _listB # 1
    ]
};

[
    _minDistance, _listA # _indexA, _listB # _indexB,
    _minDistance_2, _listA # _indexA_2, _listB # _indexB_2
]
