class EventHandlers;
class CBA_Extended_EventHandlers;
class CfgVehicles
{
    class All;
    class Static: All
    {
        class EventHandlers: EventHandlers
        {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers
            {
                dragged3DEN = "_this call sez_main_fnc_snap;";
                registeredToWorld3DEN = "_this call sez_main_fnc_snap;";
            };
        };
    };

    // Removed due to causing mission dependency on sez_main
    /*
    // Fix ACE overwrite https://github.com/acemod/ACE3/blob/master/addons/concertina_wire/CfgVehicles.hpp#L150
    class NonStrategic;
    class Land_Razorwire_F: NonStrategic {
        class EventHandlers: EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers {
                dragged3DEN = "_this call sez_main_fnc_snap;";
                registeredToWorld3DEN = "_this call sez_main_fnc_snap;";
            };
        };
    };
    */
}; // CfgVehicles
