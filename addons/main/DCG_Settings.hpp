/*
    Types (SCALAR, BOOL, STRING, ARRAY)
*/

class DOUBLES(PREFIX,settings) {
    class GVAR(blacklistLocations) {
        typeName = "ARRAY";
        value[] = {};
    };
    class GVAR(unitPoolEast) {
        typeName = "POOL";
        value[] = {
    		{"ALL","O_soldier_UAV_F","O_Soldier_TL_F","O_Sharpshooter_F","O_Soldier_lite_F","O_Soldier_LAT_F","O_Soldier_F","O_soldier_repair_F","O_Soldier_AT_F","O_Soldier_AA_F","O_soldier_M_F","O_HeavyGunner_F","O_support_MG_F","O_Soldier_GL_F","O_soldier_exp_F","O_engineer_F","O_medic_F","O_Soldier_AR_F","O_Soldier_AAT_F","O_Soldier_AAA_F","O_support_AMG_F","O_Soldier_AAR_F","O_Soldier_A_F"}
    	};
    };
    class GVAR(vehPoolEast) {
        typeName = "POOL";
        value[] = {
    		{"ALL","O_LSV_02_armed_F","O_MRAP_02_hmg_F","O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F"}
    	};
    };
    class GVAR(airPoolEast) {
        typeName = "POOL";
        value[] = {
    		{"ALL","O_Plane_CAS_02_F","O_Heli_Light_02_v2_F","O_Heli_Light_02_F","O_Heli_Attack_02_black_F","O_Heli_Attack_02_F"}
    	};
    };
    class GVAR(sniperPoolEast) {
        typeName = "POOL";
        value[] = {
    		{"ALL","O_ghillie_sard_F","O_ghillie_lsh_F","O_ghillie_ard_F","O_sniper_F"}
    	};
    };
    class GVAR(officerPoolEast) {
        typeName = "POOL";
        value[] = {
    		{"ALL","O_officer_F"}
    	};
    };
    class GVAR(artyPoolEast) {
        typeName = "POOL";
        value[] = {
    		{"ALL","O_T_MBT_02_arty_ghex_F","O_MBT_02_arty_F"}
    	};
    };
    class GVAR(staticPoolEast) {
        typeName = "POOL";
        value[] = {
            {"ALL","Inegal_Static_HMG","Inegal_Static_GMG","Genfor_Static_ZU23","Genfor_Static_DSHKM","Genfor_Static_DSHKMMiniTripod","Genfor_Static_KORD","Genfor_Static_KORDHigh","Genfor_Static_M2","Genfor_Static_M2MiniTripod","Genfor_Static_AGS","Genfor_Static_GMG","Genfor_Static_MK19","Genfor_Static_Metis","Genfor_Static_TOW","Genfor_Static_SPG9","Genfor_Static_Igla","Genfor_Static_Stinger","Genfor_Static_D30","Genfor_Static_D30AT","Genfor_Static_M119","Genfor_Static_M119AT"}
        };
    };
    class GVAR(mortarPoolEast) {
        typeName = "POOL";
        value[] = {
            {"ALL","Inegal_Static_Mortar", "Genfor_Static_2B14", "Genfor_Static_M252"}
        };
    };
    class GVAR(unitPoolInd) {
        typeName = "POOL";
        value[] = {
    		{"ALL","I_soldier_UAV_F","I_Soldier_TL_F","I_Soldier_lite_F","I_Soldier_LAT_F","I_soldier_F","I_Soldier_repair_F","I_Soldier_AT_F","I_Soldier_AA_F","I_Soldier_M_F","I_support_MG_F","I_Soldier_GL_F","I_Soldier_exp_F","I_engineer_F","I_medic_F","I_Soldier_AR_F","I_Soldier_AAT_F","I_Soldier_AAA_F","I_support_AMG_F","I_Soldier_A_F"}
    	};
    };
    class GVAR(vehPoolInd) {
        typeName = "POOL";
        value[] = {
    		{"ALL","I_MRAP_03_hmg_F","I_APC_tracked_03_cannon_F","I_APC_Wheeled_03_cannon_F"}
    	};
    };
    class GVAR(airPoolInd) {
        typeName = "POOL";
        value[] = {
    		{"ALL","I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F","I_Heli_light_03_F"}
    	};
    };
    class GVAR(sniperPoolInd) {
        typeName = "POOL";
        value[] = {
    		{"ALL","I_ghillie_sard_F","I_ghillie_lsh_F","I_ghillie_ard_F","I_Sniper_F"}
    	};
    };
    class GVAR(officerPoolInd) {
        typeName = "POOL";
        value[] = {
            {"ALL","I_officer_F"}
        };
    };
    class GVAR(artyPoolInd) {
        typeName = "POOL";
        value[] = {

        };
    };
    class GVAR(unitPoolWest) {
        typeName = "POOL";
        value[] = {
    		{"ALL","B_soldier_UAV_F","B_Soldier_TL_F","B_Sharpshooter_F","B_Soldier_lite_F","B_soldier_LAT_F","B_Soldier_F","B_soldier_repair_F","B_soldier_AT_F","B_soldier_AA_F","B_soldier_M_F","B_HeavyGunner_F","B_support_MG_F","B_Soldier_GL_F","B_soldier_exp_F","B_engineer_F","B_medic_F","B_soldier_AR_F","B_soldier_AAT_F","B_soldier_AAA_F","B_support_AMG_F","B_soldier_AAR_F","B_Soldier_A_F"}
    	};
    };
    class GVAR(vehPoolWest) {
        typeName = "POOL";
        value[] = {
    		{"ALL","B_LSV_01_armed_F","B_MRAP_01_hmg_F","B_APC_Tracked_01_rcws_F","B_APC_Tracked_01_CRV_F","B_APC_Wheeled_01_cannon_F","B_APC_Tracked_01_AA_F"}
    	};
    };
    class GVAR(airPoolWest) {
        typeName = "POOL";
        value[] = {
    		{"ALL","B_Heli_Transport_01_F","B_Heli_Transport_01_camo_F","B_Heli_Attack_01_F","B_Heli_Light_01_armed_F","B_Heli_Light_01_F"}
    	};
    };
    class GVAR(sniperPoolWest) {
        typeName = "POOL";
        value[] = {
    		{"ALL","B_ghillie_sard_F","B_ghillie_lsh_F","B_ghillie_ard_F","B_sniper_F"}
    	};
    };
    class GVAR(officerPoolWest) {
        typeName = "POOL";
        value[] = {
            {"ALL","B_officer_F"}
        };
    };
    class GVAR(artyPoolWest) {
        typeName = "POOL";
        value[] = {
    		{"ALL","B_MBT_01_mlrs_F","B_MBT_01_arty_F"}
    	};
    };
    class GVAR(unitPoolCiv) {
        typeName = "POOL";
        value[] = {
            {"ALL","C_man_hunter_1_F","C_Man_casual_3_F_euro","C_Man_casual_1_F_euro","C_man_p_beggar_F_euro","C_man_polo_4_F_euro","C_man_polo_6_F_euro","C_man_polo_3_F_asia","C_man_polo_2_F_asia","C_man_polo_1_F_asia","C_Man_casual_5_F_asia","C_man_sport_2_F_asia","C_Man_casual_3_F_asia","C_Man_casual_2_F_asia","C_Man_casual_1_F_asia","C_man_polo_3_F_afro","C_man_polo_2_F_afro","C_man_polo_1_F_afro","C_Man_casual_6_F_afro","C_Man_casual_4_F_afro","C_man_sport_1_F_afro","C_Man_casual_3_F_afro","C_Man_casual_2_F_afro","C_Man_casual_1_F_afro"}
        };
    };
    class GVAR(vehPoolCiv) {
        typeName = "POOL";
        value[] = {
    		{"ALL","C_Truck_02_covered_F","C_Truck_02_box_F","C_Truck_02_fuel_F","C_Van_01_box_F","C_Van_01_transport_F","C_SUV_01_F","C_Offroad_01_repair_F","C_Offroad_01_F","C_Offroad_02_unarmed_F","C_Hatchback_01_F","C_Van_01_fuel_F"}
    	};
    };
    class GVAR(airPoolCiv) {
        typeName = "POOL";
        value[] = {
    		{"ALL","C_Heli_Light_01_civil_F","C_Plane_Civil_01_F"}
    	};
    };
    class GVAR(vipPoolCiv) {
        typeName = "POOL";
        value[] = {
            {"ALL","C_Nikos","C_Nikos_aged"}
        };
    };
    class GVAR(suicidePool) {
        typeName = "POOL";
        value[] = {
            {"Laraka_Special_Suicide","Laraka_Special_SuicideDeadman","Laraka_Special_SuicideDiscrete","Laraka_Special_SuicideDiscreteDeadman"}
        };
    };
};
