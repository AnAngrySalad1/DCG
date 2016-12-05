#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"

//Faster Array Unwraping (skips the IS_ARRAY check normaly found in EXPLODE_1_SYS)
#undef EXPLODE_2_SYS
#define EXPLODE_1_SYS_FAST(ARRAY,A) A =(ARRAY) select 0
#define EXPLODE_2_SYS(ARRAY,A,B) EXPLODE_1_SYS_FAST(ARRAY,A); B = (ARRAY) select 1

// Default versioning level
#define DEFAULT_VERSIONING_LEVEL 2

#define EGVAR(module,var) TRIPLES(PREFIX,module,var)
#define QEGVAR(module,var) QUOTE(EGVAR(module,var))

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
#define DEFUNC(var1,var2) TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)

#define QFUNC(var1) QUOTE(DFUNC(var1))
#define QEFUNC(var1,var2) QUOTE(DEFUNC(var1,var2))

#define PATHTOEF(var1,var2) PATHTOF_SYS(PREFIX,var1,var2)

#ifndef STRING_MACROS_GUARD
#define STRING_MACROS_GUARD
    #define LSTRING(var1) QUOTE(TRIPLES(STR,ADDON,var1))
    #define ELSTRING(var1,var2) QUOTE(TRIPLES(STR,DOUBLES(PREFIX,var1),var2))
    #define CSTRING(var1) QUOTE(TRIPLES($STR,ADDON,var1))
    #define ECSTRING(var1,var2) QUOTE(TRIPLES($STR,DOUBLES(PREFIX,var1),var2))
#endif

#define GETVAR_SYS(var1,var2) getVariable [ARR_2(QUOTE(var1),var2)]
#define SETVAR_SYS(var1,var2) setVariable [ARR_2(QUOTE(var1),var2)]
#define SETPVAR_SYS(var1,var2) setVariable [ARR_3(QUOTE(var1),var2,true)]

#define GETVAR(var1,var2,var3) var1 GETVAR_SYS(var2,var3)
#define GETMVAR(var1,var2) missionNamespace GETVAR_SYS(var1,var2)
#define GETUVAR(var1,var2) uiNamespace GETVAR_SYS(var1,var2)
#define GETPRVAR(var1,var2) profileNamespace GETVAR_SYS(var1,var2)
#define GETPAVAR(var1,var2) parsingNamespace GETVAR_SYS(var1,var2)

#define SETVAR(var1,var2,var3) var1 SETVAR_SYS(var2,var3)
#define SETPVAR(var1,var2,var3) var1 SETPVAR_SYS(var2,var3)
#define SETMVAR(var1,var2) missionNamespace SETVAR_SYS(var1,var2)
#define SETUVAR(var1,var2) uiNamespace SETVAR_SYS(var1,var2)
#define SETPRVAR(var1,var2) profileNamespace SETVAR_SYS(var1,var2)
#define SETPAVAR(var1,var2) parsingNamespace SETVAR_SYS(var1,var2)

#define GETGVAR(var1,var2) GETMVAR(GVAR(var1),var2)
#define GETEGVAR(var1,var2,var3) GETMVAR(EGVAR(var1,var2),var3)

#define ARR_SELECT(ARRAY,INDEX,DEFAULT) if (count ARRAY > INDEX) then {ARRAY select INDEX} else {DEFAULT}

#define MACRO_ADDWEAPON(WEAPON,COUNT) class _xx_##WEAPON { \
  weapon = #WEAPON; \
  count = COUNT; \
}

#define MACRO_ADDITEM(ITEM,COUNT) class _xx_##ITEM { \
  name = #ITEM; \
  count = COUNT; \
}

#define MACRO_ADDMAGAZINE(MAGAZINE,COUNT) class _xx_##MAGAZINE { \
  magazine = #MAGAZINE; \
  count = COUNT; \
}

#define MACRO_ADDBACKPACK(BACKPACK,COUNT) class _xx_##BACKPACK { \
  backpack = #BACKPACK; \
  count = COUNT; \
}

#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#define ADDON_TITLE (toUpper QUOTE(ADDON)) splitString "_" joinString " "

#define DATA_SAVEVAR QUOTE(DOUBLES(MAIN_ADDON,saveData))
#define DATA_SAVEPVEH QUOTE(DOUBLES(MAIN_ADDON,saveDataPVEH))
#define DATA_DELETEPVEH QUOTE(DOUBLES(MAIN_ADDON,deleteDataPVEH))
#define DATA_OBJVAR QUOTE(DOUBLES(MAIN_ADDON,saveObject))
#define DATA_SETVAR(VAR1) profileNamespace setVariable [DATA_SAVEVAR,VAR1]
#define DATA_GETVAR profileNamespace getVariable [DATA_SAVEVAR,[]]
#define DATA_MISSION_ID ([toUpper worldName, toUpper missionName] joinString "_")

#define HEADLESSCLIENT Jarvis

#define ACTIONPATH ["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(ADDON)]

#define SPAWNED_DRIVER QEGVAR(main,DOUBLES(spawned,driver))

#define CHECK_INIT if !((EGVAR(main,enable) isEqualTo 1) && {isServer} && {isMultiplayer}) exitWith {}
#define CHECK_DEBUG (EGVAR(main,debug) isEqualTo 1)
#define CHECK_MARKER(MARKER) (getMarkerColor MARKER != '')
#define CHECK_ADDON_1(PATCH) (isClass (configfile >> 'CfgPatches' >> PATCH))
#define CHECK_ADDON_2(VAR) (CHECK_ADDON_1(QUOTE(DOUBLES(PREFIX,VAR))) && {EGVAR(VAR,enable) isEqualTo 1})
#define CHECK_DIST(POS1,POS2,DIST) (POS1) distance (POS2) <= (DIST)
#define CHECK_DIST2D(POS1,POS2,DIST) (POS1) distance2D (POS2) <= (DIST)
#define CHECK_VECTORDIST(POS1,POS2,DIST) (POS1) vectorDistance (POS2) <= (DIST)
#define CHECK_ADDON \
    if (GVAR(enable) isEqualTo 0) exitWith { \
    	INFO("Addon is disabled"); \
    }

#define COMPARE_STR(STR1,STR2) ((STR1) == (STR2))
#define COMPARE_STR_CASE(STR1,STR2) ((STR1) isEqualTo (STR2))

#define CACHE_DISABLE_VAR QUOTE(TRIPLES(PREFIX,cache,disableCaching))
#define CACHE_DISABLE(GRP,BOOL) GRP setVariable [CACHE_DISABLE_VAR,BOOL,true]

#define PVEH_AVADD QEGVAR(approval,pveh_add)
#define AV_LOCATION_ID(LOCATION) ([QUOTE(PREFIX),"approval",LOCATION] joinString "_")
#define AV_MIN 0
#define AV_MAX 100
#define AV_CAR ((AV_MAX*0.005)*EGVAR(approval,multiplier))
#define AV_TANK ((AV_MAX*0.0075)*EGVAR(approval,multiplier))
#define AV_AIR ((AV_MAX*0.01)*EGVAR(approval,multiplier))
#define AV_SHIP ((AV_MAX*0.005)*EGVAR(approval,multiplier))
#define AV_MAN ((AV_MAX*0.001)*EGVAR(approval,multiplier))
#define AV_CIV ((AV_MAX*0.01)*EGVAR(approval,multiplier))
#define AV_FOB ((AV_MAX*0.01)*EGVAR(approval,multiplier))
#define AV_PB ((AV_MAX*0.005)*EGVAR(approval,multiplier))
#define AV_VILLAGE ((AV_MAX*0.05)*EGVAR(approval,multiplier))
#define AV_CITY ((AV_MAX*0.1)*EGVAR(approval,multiplier))
#define AV_CAPITAL ((AV_MAX*0.15)*EGVAR(approval,multiplier))
#define AV_CHANCE(POS) ((1 - (linearConversion [AV_MIN, AV_MAX, [POS] call EFUNC(approval,getValue), 0, 1, true])) * 0.5)
