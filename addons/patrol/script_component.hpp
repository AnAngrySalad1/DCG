#define COMPONENT patrol

#include "\d\dcg\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define UNITCOUNT(MIN,MAX) floor (random ((MAX - MIN) + 1)) + MIN
#define PATROL_MINRANGE 100
#define PATROL_RANGE 800