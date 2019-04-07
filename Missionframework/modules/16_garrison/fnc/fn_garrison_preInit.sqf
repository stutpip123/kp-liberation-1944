/*
    KPLIB_fnc_garrison_preInit

    File: fn_garrison_preInit.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2018-10-18
    Last Update: 2019-03-30
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html
    Public: No

    Description:
        The preInit function defines global variables, adds event handlers and set some vital settings which are used in this module.

    Parameter(s):
        NONE

    Returns:
        Module preInit finished [BOOL]
*/

if (isServer) then {diag_log format ["[KP LIBERATION] [%1] [PRE] [GARRISON] Module initializing...", diag_tickTime];};

/*
    ----- Module Globals -----
*/

// Array to collect active garrison units
KPLIB_garrison_active = [];

// Array which contains all garrisons
KPLIB_garrison_array = [];


/*
    ----- Module Initialization -----
*/

if (isServer) then {
    // Register load event handler
    ["KPLIB_doLoad", {[] call KPLIB_fnc_garrison_loadData;}] call CBA_fnc_addEventHandler;

    // Register save event handler
    ["KPLIB_doSave", {[] call KPLIB_fnc_garrison_saveData;}] call CBA_fnc_addEventHandler;

    // Register sector activation event handler
    ["KPLIB_sector_activated", {[_this select 0] call KPLIB_fnc_garrison_spawn;}] call CBA_fnc_addEventHandler;

    // Register sector captured event handler
    ["KPLIB_sector_captured", {[_this select 0] call KPLIB_fnc_garrison_changeOwner;}] call CBA_fnc_addEventHandler;

    // Register sector deactivation event handler
    ["KPLIB_sector_deactivated", {[_this select 0] call KPLIB_fnc_garrison_despawn;}] call CBA_fnc_addEventHandler;

    // Indicator for presets initialization
    KPLIB_garrison_presetInitE = false;
    KPLIB_garrison_presetInitF = false;

    // Register preset change event handler (The if is needed, because this event is also fired on mission start, not only on change)
    ["CBA_SettingChanged", {
        params ["_setting", "_value"];

        switch (_setting) do {
            case "KPLIB_param_presetE": {
                if (!KPLIB_garrison_presetInitE) then {
                    KPLIB_garrison_presetInitE = true;
                } else {
                    [_setting] call KPLIB_fnc_garrison_reInitSectors;
                };
            };
            case "KPLIB_param_presetF": {
                if (!KPLIB_garrison_presetInitF) then {
                    KPLIB_garrison_presetInitF = true;
                } else {
                    [_setting] call KPLIB_fnc_garrison_reInitSectors;
                };
            };
            default {};
        };
    }] call CBA_fnc_addEventHandler;
};

if (isServer) then {diag_log format ["[KP LIBERATION] [%1] [PRE] [GARRISON] Module initialized", diag_tickTime];};

true
