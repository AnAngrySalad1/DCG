/*
    Types (SCALAR, BOOL, STRING, ARRAY)
*/

class DOUBLES(PREFIX,settings) {
    class GVAR(enable) {
        typeName = "SCALAR";
        typeDetail = "";
        value = 1;
    };
    class GVAR(season) {
        typeName = "SCALAR";
        typeDetail = "";
        value = -1;
    };
    class GVAR(time) {
        typeName = "SCALAR";
        typeDetail = "";
        value = -1;
    };
    class GVAR(mapData) { // weatherspark.com
        typeName = "ARRAY";
        typeDetail = "WORLD";
        value[] = {
            {"ALTIS",0.67,0.65,0.56,0.52,0.44,0.34,0.26,0.27,0.33,0.47,0.54,0.62},
            {"STRATIS",0.67,0.65,0.56,0.52,0.44,0.34,0.26,0.27,0.33,0.47,0.54,0.62},
            {"TAKISTAN",0.54,0.60,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41},
            {"KUNDUZ",0.54,0.60,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41},
            {"MOUNTAINS_ACR",0.54,0.60,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41},
            {"CHERNARUS",0.98,0.94,0.85,0.76,0.70,0.74,0.70,0.64,0.73,0.84,0.93,0.97},
            {"CHERNARUS_SUMMER",0.73,0.72,0.70,0.72,0.74,0.70,0.68,0.65,0.64,0.69,0.70,0.75},
            {"TANOA",0.80,0.78,0.70,0.63,0.57,0.55,0.48,0.49,0.57,0.64,0.71,0.79}
        };
    };
};