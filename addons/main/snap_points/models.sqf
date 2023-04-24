private _models = [
    "Ind_Expedice_1.p3d",
    "Ind_Expedice_2.p3d",
    "Ind_Expedice_3.p3d"
];

private _position = AGLToASL positionCameraToWorld [0, 0, 0];
_models apply {
    _m = createSimpleObject [_x, _position];
    _position = _position vectorAdd [0, 0, (boundingBox _m # 2) * 2];
    [_x, (selectionNames _m)]
    //[_x, (selectionNames _m) select {"snap" in _x} apply {_m selectionPosition _x}]
};
