* CODE TO CALCULATE CONVERT THE TIMESTEP USED - JUAN GEA BERMUDEZ
* Important note: make sure the full year data is used, otherwise there will be errors in some files

*---------- DATA DEFINITION--------------------
*Possible conversion of timesteps

$setglobal timestep_conversion WeeksHours_DaysHours
*!option WeeksHours_DaysHours
*!option WeeksHours_HoursHours
*!option DaysHours_HoursHours
*!option DaysHours_Hours5min

$ifi  %timestep_conversion%==WeeksHours_DaysHours  SET SSS /S01*S52/;
$ifi  %timestep_conversion%==WeeksHours_DaysHours  SET TTT /T001*T168/;
$ifi  %timestep_conversion%==WeeksHours_DaysHours  SET SSS_NEW /S001*S364/;
$ifi  %timestep_conversion%==WeeksHours_DaysHours  SET TTT_NEW /T01*T24/;

$ifi  %timestep_conversion%==WeeksHours_HoursHours  SET SSS /S01*S52/;
$ifi  %timestep_conversion%==WeeksHours_HoursHours  SET TTT /T001*T168/;
$ifi  %timestep_conversion%==WeeksHours_HoursHours  SET SSS_NEW /S0001*S8736/;
$ifi  %timestep_conversion%==WeeksHours_HoursHours  SET TTT_NEW /T01/;

$ifi  %timestep_conversion%==DaysHours_HoursHours  SET SSS /S001*S364/;
$ifi  %timestep_conversion%==DaysHours_HoursHours  SET TTT /T01*T24/;
$ifi  %timestep_conversion%==DaysHours_HoursHours  SET SSS_NEW /S0001*S8736/;
$ifi  %timestep_conversion%==DaysHours_HoursHours  SET TTT_NEW /T01/;

$ifi  %timestep_conversion%==DaysHours_Hours5min  SET SSS /S001*S364/;
$ifi  %timestep_conversion%==DaysHours_Hours5min  SET TTT /T01*T24/;
$ifi  %timestep_conversion%==DaysHours_Hours5min  SET SSS_NEW /S0001*S8736/;
$ifi  %timestep_conversion%==DaysHours_Hours5min  SET TTT_NEW /T01*T12/;

SET ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW);
$ifi  %timestep_conversion%==WeeksHours_DaysHours   $INCLUDE   '../../base/auxils/timestep_conversion/input/ST_LINK_WeeksHours_DaysHours.inc';
$ifi  %timestep_conversion%==WeeksHours_HoursHours  $INCLUDE   '../../base/auxils/timestep_conversion/input/ST_LINK_WeeksHours_HoursHours.inc';
$ifi  %timestep_conversion%==DaysHours_HoursHours   $INCLUDE   '../../base/auxils/timestep_conversion/input/ST_LINK_DaysHours_HoursHours.inc';
$ifi  %timestep_conversion%==DaysHours_Hours5min    $INCLUDE   '../../base/auxils/timestep_conversion/input/ST_LINK_DaysHours_Hours5min.inc';

SET S_LINK(SSS,SSS_NEW);
$ifi  %timestep_conversion%==WeeksHours_DaysHours   $INCLUDE   '../../base/auxils/timestep_conversion/input/S_LINK_WeeksHours_DaysHours.inc';
$ifi  %timestep_conversion%==WeeksHours_HoursHours  $INCLUDE   '../../base/auxils/timestep_conversion/input/S_LINK_WeeksHours_HoursHours.inc';
$ifi  %timestep_conversion%==DaysHours_HoursHours   $INCLUDE   '../../base/auxils/timestep_conversion/input/S_LINK_DaysHours_HoursHours.inc';
$ifi  %timestep_conversion%==DaysHours_Hours5min    $INCLUDE   '../../base/auxils/timestep_conversion/input/S_LINK_DaysHours_Hours5min.inc';


ALIAS(SSS_NEW,ISSS_NEW);
ALIAS(SSS,ISSS);
ALIAS(TTT_NEW,ITTT_NEW);
ALIAS(TTT,ITTT);


SET CCCRRRAAA          "All geographical entities (CCC + RRR + AAA)" ;
$INCLUDE         '../data/CCCRRRAAA.inc';
$include   "../../base/addons/offshoregrid/bb4/offshoregrid_cccrrraaaadditions.inc";
$include   "../../base/addons/industry/bb4/industry_cccrrraaaadditions.inc";

SET RRR(CCCRRRAAA)       "All regions" ;
$INCLUDE         '../data/RRR.inc';
$include   "../../base/addons/offshoregrid/bb4/offshoregrid_rrradditions.inc";

ALIAS(RRR,IRRR);

SET AAA(CCCRRRAAA)       "All areas";
$INCLUDE         '../data/AAA.inc';
$include   "../../base/addons/offshoregrid/bb4/offshoregrid_aaaadditions.inc";
$include   "../../base/addons/industry/bb4/industry_aaaadditions.inc";

ALIAS(AAA,IAAA);

SET DEUSER             "Electricity demand user groups. Set must include element RESE for holding demand not included in any other user group" ;
$INCLUDE         '../data/DEUSER.inc';

SET DHUSER             "Heat demand user groups. Set must include element RESH for holding demand not included in any other user group"  ;
$INCLUDE         '../data/DHUSER.inc';

SET GGG          "All generation technologies"   ;
$INCLUDE         '../data/GGG.inc';

SET FFF       "All fuels"
$INCLUDE         '../data/FFF.inc';

SET YYY                "All years" ;
$INCLUDE         '../data/YYY.inc';

SET HYRSDATASET  "Characteristics of hydro reservoirs" ;
$INCLUDE         '../data/HYRSDATASET.inc';

PARAMETER GMAXF(YYY,CCCRRRAAA,FFF)  "Maximum annual fuel use by year, geography and fuel and (GJ)";
$INCLUDE         '../data/GMAXF.inc';

PARAMETER GMAXFS(YYY,CCCRRRAAA,FFF,SSS)  "Maximum annual fuel use by year, season, geography and fuel and (GJ)";
$INCLUDE         '../data/GMAXFS.inc';

*Original timeseries
PARAMETER WND_VAR_T(AAA,SSS,TTT)                   "Variation of the wind generation"    ;
execute_load  '../../base/auxils/timestep_conversion/input/INPUTDATAOUT.gdx', WND_VAR_T;

PARAMETER SOLE_VAR_T(AAA,SSS,TTT)                  "Variation of the solarE generation"   ;
execute_load  '../../base/auxils/timestep_conversion/input/INPUTDATAOUT.gdx', SOLE_VAR_T;

PARAMETER SOLH_VAR_T(AAA,SSS,TTT)                  "Variation of the solarH generation"   ;
execute_load  '../../base/auxils/timestep_conversion/input/INPUTDATAOUT.gdx', SOLH_VAR_T;

PARAMETER WTRRSVAR_S(AAA,SSS)                      "Variation of the water inflow to reservoirs"   ;
execute_load  '../../base/auxils/timestep_conversion/input/INPUTDATAOUT.gdx', WTRRSVAR_S;

PARAMETER WTRRRVAR_T(AAA,SSS,TTT)                  "Variation of generation of hydro run-of-river"  ;
execute_load  '../../base/auxils/timestep_conversion/input/INPUTDATAOUT.gdx', WTRRRVAR_T;

PARAMETER HYRSDATA(AAA,HYRSDATASET,SSS)    "Data for hydro with storage"  ;
execute_load  '../../base/auxils/timestep_conversion/input/INPUTDATAOUT.gdx', HYRSDATA;

PARAMETER HYPPROFILS(AAA,SSS)                      "Hydro with storage seasonal price profile" ;
execute_load  '../../base/auxils/timestep_conversion/input/INPUTDATAOUT.gdx', HYPPROFILS;

PARAMETER GKRATE(AAA,GGG,SSS)                       "Capacity rating (non-negative, typically close to 1; default/1/, use eps for 0)" ;
execute_load  '../../base/auxils/timestep_conversion/input/INPUTDATAOUT.gdx', GKRATE;

PARAMETER DE_VAR_T(RRR,DEUSER,SSS,TTT)                    "Variation in electricity demand"   ;
execute_load  '../../base/auxils/timestep_conversion/input/INPUTDATAOUT.gdx', DE_VAR_T;

PARAMETER DH_VAR_T(AAA,DHUSER,SSS,TTT)                    "Variation in heat demand"   ;
execute_load  '../../base/auxils/timestep_conversion/input/INPUTDATAOUT.gdx', DH_VAR_T;

PARAMETER WEIGHT_S(SSS)                            "Weight (relative length) of each season"    ;
execute_load  '../../base/auxils/timestep_conversion/input/INPUTDATAOUT.gdx', WEIGHT_S;

PARAMETER WEIGHT_T(TTT)                            "Weight (relative length) of each time period"  ;
execute_load  '../../base/auxils/timestep_conversion/input/INPUTDATAOUT.gdx', WEIGHT_T;

PARAMETER ESTOVOLTS(YYY,AAA,GGG,SSS,TTT) "Inter-seasonal Electricity storage contents at beginning of time segment (MWh) to be transferred to future runs (MWh)";
execute_load  '../../base/auxils/timestep_conversion/input/ESTOVOLTS.gdx', ESTOVOLTS;

PARAMETER HSTOVOLTS(YYY,AAA,GGG,SSS,TTT) "Inter-seasonal Heat storage contents at beginning of time segment (MWh) to be transferred to future runs (MWh)";
execute_load  '../../base/auxils/timestep_conversion/input/HSTOVOLTS.gdx', HSTOVOLTS;

PARAMETER ESTOVOLTSVAL(YYY,AAA,GGG,SSS,TTT) "Inter-seasonal Electricity storage content  value (in input money) to be transferred to future runs (input-Money/MWh)";
execute_load  '../../base/auxils/timestep_conversion/input/ESTOVOLTSVAL.gdx', ESTOVOLTSVAL;

PARAMETER HSTOVOLTSVAL(YYY,AAA,GGG,SSS,TTT) "Inter-seasonal Heat storage content value (in input money) to be transferred to future runs (input-Money/MWh)";
execute_load  '../../base/auxils/timestep_conversion/input/HSTOVOLTSVAL.gdx', HSTOVOLTSVAL;

PARAMETER ESTOVOLT(YYY,AAA,GGG,SSS,TTT) "Intra-seasonal Electricity storage contents at beginning of time segment (MWh) to be transferred to future runs (MWh)";
execute_load  '../../base/auxils/timestep_conversion/input/ESTOVOLT.gdx', ESTOVOLT;

PARAMETER HSTOVOLT(YYY,AAA,GGG,SSS,TTT) "Intra-seasonal Heat storage contents at beginning of time segment (MWh) to be transferred to future runs (MWh)";
execute_load  '../../base/auxils/timestep_conversion/input/HSTOVOLT.gdx', HSTOVOLT;

PARAMETER ESTOVOLTVAL(YYY,AAA,GGG,SSS,TTT) "Intra-seasonal Electricity storage content  value (in input money) to be transferred to future runs (input-Money/MWh)";
execute_load  '../../base/auxils/timestep_conversion/input/ESTOVOLTVAL.gdx', ESTOVOLTVAL;

PARAMETER HSTOVOLTVAL(YYY,AAA,GGG,SSS,TTT) "Intra-seasonal Heat storage content value (in input money) to be transferred to future runs (input-Money/MWh)";
execute_load  '../../base/auxils/timestep_conversion/input/HSTOVOLTVAL.gdx', HSTOVOLTVAL;

PARAMETER  DE_T(YYY,RRR,SSS,TTT)                 "Electricity demand (MW) to be transferred to future runs";
execute_load  '../../base/auxils/timestep_conversion/input/DE_T.gdx', DE_T;

PARAMETER  DH_T(YYY,AAA,SSS,TTT)                 "Heat demand (MW) to be transferred to future runs";
execute_load  '../../base/auxils/timestep_conversion/input/DH_T.gdx', DH_T;

PARAMETER  GE_T(YYY,AAA,GGG,SSS,TTT)               "Electricity generation (MW)  to be transferred to future runs";
execute_load  '../../base/auxils/timestep_conversion/input/GE_T.gdx', GE_T;

PARAMETER  GH_T(YYY,AAA,GGG,SSS,TTT)               "Heat generation (MW)  to be transferred to future runs";
execute_load  '../../base/auxils/timestep_conversion/input/GH_T.gdx', GH_T;

PARAMETER  GF_T(YYY,AAA,GGG,SSS,TTT)               "Fuel consumption rate (MW), existing units  to be transferred to future runs";
execute_load  '../../base/auxils/timestep_conversion/input/GF_T.gdx', GF_T;

PARAMETER ESTOLOADT(YYY,AAA,GGG,SSS,TTT) "Intra-seasonal electricity storage loading to be transferred to future runs (MW)";
execute_load  '../../base/auxils/timestep_conversion/input/ESTOLOADT.gdx', ESTOLOADT;

PARAMETER ESTOLOADTS(YYY,AAA,GGG,SSS,TTT) "Inter-seasonal electricity storage loading to be transferred to future runs (MW)";;
execute_load  '../../base/auxils/timestep_conversion/input/ESTOLOADTS.gdx', ESTOLOADTS;

PARAMETER HSTOLOADT(YYY,AAA,GGG,SSS,TTT)  "Intra-seasonal heat storage loading to be transferred to future runs (MW)";
execute_load  '../../base/auxils/timestep_conversion/input/HSTOLOADT.gdx', HSTOLOADT;

PARAMETER HSTOLOADTS(YYY,AAA,GGG,SSS,TTT) "Inter-seasonal heat storage loading to be transferred to future runs (MW)";
execute_load  '../../base/auxils/timestep_conversion/input/HSTOLOADTS.gdx', HSTOLOADTS;

PARAMETER  X_T(YYY,RRR,RRR,SSS,TTT)          "Electricity export from region IRRRE to IRRRI to be transferred to future runs (MW)";
execute_load  '../../base/auxils/timestep_conversion/input/X_T.gdx', X_T;

PARAMETER  XH_T(YYY,AAA,AAA,SSS,TTT)          "Heat export from region IAAAE to IAAAI to be transferred to future runs (MW)";
execute_load  '../../base/auxils/timestep_conversion/input/XH_T.gdx', XH_T;

PARAMETER HYRSG(YYY,AAA,SSS)        "Water (hydro) generation quantity of the seasons to be transferred to future runs (MWh)";
execute_load  '../../base/auxils/timestep_conversion/input/HYRSG.gdx', HYRSG;

PARAMETER VHYRS_SL(YYY,AAA,SSS)       "Hydro storage content at the beginning of each season (initial letter is V although declared as a parameter) (MWh)"
execute_load  '../../base/auxils/timestep_conversion/input/VHYRS_SL.gdx', VHYRS_SL;

PARAMETER VHYRS_STL(YYY,AAA,SSS,TTT)       "Hydro storage content at the beginning of each TTT (initial letter is V although declared as a parameter) (MWh)"
execute_load  '../../base/auxils/timestep_conversion/input/VHYRS_STL.gdx', VHYRS_STL;

PARAMETER WATERVAL(YYY,AAA,SSS)     "Water value (in input Money) to be transferred to future runs (input-Money/MWh)";
execute_load  '../../base/auxils/timestep_conversion/input/WATERVAL.gdx', WATERVAL;

PARAMETER F_T(YYY,CCCRRRAAA,FFF,SSS,TTT) "Aggregated fuel use by year, season, T, geography and fuel (GJ)"
execute_load  '../../base/auxils/timestep_conversion/input/F_T.gdx', F_T;

*REST OF HYDRO PARAMETERS.........

*New timeseries
PARAMETER WND_VAR_T_NEW(AAA,SSS_NEW,TTT_NEW)                   "Variation of the wind generation"    ;
PARAMETER SOLE_VAR_T_NEW(AAA,SSS_NEW,TTT_NEW)                  "Variation of the solarE generation"   ;
PARAMETER SOLH_VAR_T_NEW(AAA,SSS_NEW,TTT_NEW)                  "Variation of the solarH generation"   ;
PARAMETER GKRATE_NEW(AAA,GGG,SSS_NEW)                       "Capacity rating (non-negative, typically close to 1; default/1/, use eps for 0)" ;
PARAMETER WTRRSVAR_S_NEW(AAA,SSS_NEW)                        "Variation of the water inflow to reservoirs"   ;
PARAMETER WTRRRVAR_T_NEW(AAA,SSS_NEW,TTT_NEW)                  "Variation of generation of hydro run-of-river"  ;
PARAMETER HYRSDATA_NEW(AAA,HYRSDATASET,SSS_NEW)           "Data for hydro with storage"  ;
PARAMETER HYPPROFILS_NEW(AAA,SSS_NEW)                      "Hydro with storage seasonal price profile" ;
PARAMETER DE_VAR_T_NEW(RRR,DEUSER,SSS_NEW,TTT_NEW)                    "Variation in electricity demand"   ;
PARAMETER DH_VAR_T_NEW(AAA,DHUSER,SSS_NEW,TTT_NEW)                    "Variation in heat demand"   ;
PARAMETER WEIGHT_S_NEW(SSS_NEW)                            "Weight (relative length) of each season"    ;
PARAMETER WEIGHT_T_NEW(TTT_NEW)                            "Weight (relative length) of each time period" ;

PARAMETER ESTOVOLTS_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW) "Inter-seasonal Electricity storage contents at beginning of time segment (MWh) to be transferred to future runs (MWh)";
PARAMETER HSTOVOLTS_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW) "Inter-seasonal Heat storage contents at beginning of time segment (MWh) to be transferred to future runs (MWh)";
PARAMETER ESTOVOLTSVAL_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW) "Inter-seasonal Electricity storage content  value (in input money) to be transferred to future runs (input-Money/MWh)";
PARAMETER HSTOVOLTSVAL_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW) "Inter-seasonal Heat storage content value (in input money) to be transferred to future runs (input-Money/MWh)";
PARAMETER ESTOVOLT_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW) "Intra-seasonal Electricity storage contents at beginning of time segment (MWh) to be transferred to future runs (MWh)";
PARAMETER HSTOVOLT_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW) "Intra-seasonal Heat storage contents at beginning of time segment (MWh) to be transferred to future runs (MWh)";
PARAMETER ESTOVOLTVAL_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW) "Intra-seasonal Electricity storage content  value (in input money) to be transferred to future runs (input-Money/MWh)";
PARAMETER HSTOVOLTVAL_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW) "Intra-seasonal Heat storage content value (in input money) to be transferred to future runs (input-Money/MWh)";
PARAMETER  DE_T_NEW(YYY,RRR,SSS_NEW,TTT_NEW)                 "Electricity demand (MW) to be transferred to future runs";
PARAMETER  DH_T_NEW(YYY,AAA,SSS_NEW,TTT_NEW)                 "Heat demand (MW) to be transferred to future runs";
PARAMETER  GE_T_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)               "Electricity generation (MW)  to be transferred to future runs";
PARAMETER  GH_T_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)               "Heat generation (MW)  to be transferred to future runs";
PARAMETER  GF_T_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)               "Fuel consumption rate (MW), existing units  to be transferred to future runs";
PARAMETER ESTOLOADT_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW) "Intra-seasonal electricity storage loading to be transferred to future runs (MW)";
PARAMETER ESTOLOADTS_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW) "Inter-seasonal electricity storage loading to be transferred to future runs (MW)";;
PARAMETER HSTOLOADT_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)  "Intra-seasonal heat storage loading to be transferred to future runs (MW)";
PARAMETER HSTOLOADTS_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW) "Inter-seasonal heat storage loading to be transferred to future runs (MW)";
PARAMETER  X_T_NEW(YYY,RRR,RRR,SSS_NEW,TTT_NEW)          "Electricity export from region IRRRE to IRRRI to be transferred to future runs (MW)";
PARAMETER  XH_T_NEW(YYY,AAA,AAA,SSS_NEW,TTT_NEW)          "Heat export from region IAAAE to IAAAI to be transferred to future runs (MW)";
PARAMETER HYRSG_NEW(YYY,AAA,SSS_NEW)        "Water (hydro) generation quantity of the seasons to be transferred to future runs (MWh)";
PARAMETER VHYRS_SL_NEW(YYY,AAA,SSS_NEW)       "To be saved for comparison with BB1/BB2 solution value for VHYRS_S.L (initial letter is V although declared as a parameter) (MWh)"
PARAMETER WATERVAL_NEW(YYY,AAA,SSS_NEW)     "Water value (in input Money) to be transferred to future runs (input-Money/MWh)";
PARAMETER GMAXFS_NEW(YYY,CCCRRRAAA,FFF,SSS_NEW)  "Minimum annual fuel use by year, season, geography and fuel and (GJ)";

*----------END OF INPUT DATA--------------------


*------------CALCULATIONS-------------


WND_VAR_T_NEW(AAA,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),WND_VAR_T(AAA,SSS,TTT));
SOLE_VAR_T_NEW(AAA,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),SOLE_VAR_T(AAA,SSS,TTT));
SOLH_VAR_T_NEW(AAA,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),SOLH_VAR_T(AAA,SSS,TTT));
GKRATE_NEW(AAA,GGG,SSS_NEW)=SUM(SSS$S_LINK(SSS,SSS_NEW),GKRATE(AAA,GGG,SSS));
WTRRSVAR_S_NEW(AAA,SSS_NEW)=SUM(SSS$S_LINK(SSS,SSS_NEW),WTRRSVAR_S(AAA,SSS));
WTRRRVAR_T_NEW(AAA,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),WTRRRVAR_T(AAA,SSS,TTT));
HYRSDATA_NEW(AAA,HYRSDATASET,SSS_NEW)=SUM(SSS$S_LINK(SSS,SSS_NEW),HYRSDATA(AAA,HYRSDATASET,SSS));
HYPPROFILS_NEW(AAA,SSS_NEW)=SUM(SSS$S_LINK(SSS,SSS_NEW),HYPPROFILS(AAA,SSS));
DE_VAR_T_NEW(RRR,DEUSER,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),DE_VAR_T(RRR,DEUSER,SSS,TTT));
DH_VAR_T_NEW(AAA,DHUSER,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),DH_VAR_T(AAA,DHUSER,SSS,TTT));
ESTOVOLTS_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),ESTOVOLTS(YYY,AAA,GGG,SSS,TTT)) ;
HSTOVOLTS_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),HSTOVOLTS(YYY,AAA,GGG,SSS,TTT));
ESTOVOLTSVAL_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),ESTOVOLTSVAL(YYY,AAA,GGG,SSS,TTT));
HSTOVOLTSVAL_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),HSTOVOLTSVAL(YYY,AAA,GGG,SSS,TTT)) ;
ESTOVOLT_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),ESTOVOLT(YYY,AAA,GGG,SSS,TTT)) ;
HSTOVOLT_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),HSTOVOLT(YYY,AAA,GGG,SSS,TTT)) ;
ESTOVOLTVAL_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),ESTOVOLTVAL(YYY,AAA,GGG,SSS,TTT)) ;
HSTOVOLTVAL_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),HSTOVOLTVAL(YYY,AAA,GGG,SSS,TTT));
DE_T_NEW(YYY,RRR,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),DE_T(YYY,RRR,SSS,TTT))               ;
DH_T_NEW(YYY,AAA,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),DH_T(YYY,AAA,SSS,TTT))                ;
GE_T_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),GE_T(YYY,AAA,GGG,SSS,TTT))               ;
GH_T_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),GH_T(YYY,AAA,GGG,SSS,TTT))              ;
GF_T_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),GF_T(YYY,AAA,GGG,SSS,TTT))              ;
ESTOLOADT_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),ESTOLOADT(YYY,AAA,GGG,SSS,TTT)) ;
ESTOLOADTS_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),ESTOLOADTS(YYY,AAA,GGG,SSS,TTT)) ;
HSTOLOADT_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),HSTOLOADT(YYY,AAA,GGG,SSS,TTT)) ;
HSTOLOADTS_NEW(YYY,AAA,GGG,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),HSTOLOADTS(YYY,AAA,GGG,SSS,TTT)) ;
X_T_NEW(YYY,RRR,IRRR,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),X_T(YYY,RRR,IRRR,SSS,TTT))         ;
XH_T_NEW(YYY,AAA,IAAA,SSS_NEW,TTT_NEW)=SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),XH_T(YYY,AAA,IAAA,SSS,TTT))         ;
HYRSG_NEW(YYY,AAA,SSS_NEW)=SUM(SSS$S_LINK(SSS,SSS_NEW),HYRSG(YYY,AAA,SSS));
VHYRS_SL_NEW(YYY,AAA,SSS_NEW)=SUM(TTT_NEW$(ORD(TTT_NEW) EQ 1), SUM((SSS,TTT)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),VHYRS_STL(YYY,AAA,SSS,TTT)));
WATERVAL_NEW(YYY,AAA,SSS_NEW)=SUM(SSS$S_LINK(SSS,SSS_NEW),WATERVAL(YYY,AAA,SSS));
GMAXFS_NEW(YYY,CCCRRRAAA,FFF,SSS_NEW)$(GMAXF(YYY,CCCRRRAAA,FFF) OR SUM(ISSS,GMAXFS(YYY,CCCRRRAAA,FFF,ISSS)))=SUM((SSS,TTT,TTT_NEW)$ST_LINK(SSS,TTT,SSS_NEW,TTT_NEW),F_T(YYY,CCCRRRAAA,FFF,SSS,TTT)*WEIGHT_S(SSS))/SUM(TTT, WEIGHT_T(TTT));


$ifi  NOT %timestep_conversion%==WeeksHours_DaysHours   $goto No_WeeksHours_DaysHours

WEIGHT_S_NEW(SSS_NEW)=24;
WEIGHT_T_NEW(TTT_NEW)=1;

$label No_WeeksHours_DaysHours

$ifi  NOT %timestep_conversion%==WeeksHours_HoursHours   $goto No_WeeksHours_HoursHours
WEIGHT_S_NEW(SSS_NEW)=1;
WEIGHT_T_NEW(TTT_NEW)=1;
$label No_WeeksHours_HoursHours

$ifi  NOT %timestep_conversion%==DaysHours_HoursHours   $goto No_DaysHours_HoursHours
WEIGHT_S_NEW(SSS_NEW)=1;
WEIGHT_T_NEW(TTT_NEW)=1;
$label No_DaysHours_HoursHours

$ifi  NOT %timestep_conversion%==DaysHours_Hours5min   $goto No_DaysHours_Hours5min
WEIGHT_S_NEW(SSS_NEW)=1;
WEIGHT_T_NEW(TTT_NEW)=1/12;
$label No_DaysHours_Hours5min

*------------END OF CALCULATIONS-------------





*------------OUTPUT GENERATION-------------


execute_unload  '../../base/auxils/timestep_conversion/output/converted_timesteps.gdx',
ST_LINK,S_LINK,
WND_VAR_T_NEW=WND_VAR_T,
SOLE_VAR_T_NEW=SOLE_VAR_T,
SOLH_VAR_T_NEW=SOLH_VAR_T,
GKRATE_NEW=GKRATE,
WTRRSVAR_S_NEW=WTRRSVAR_S,
WTRRRVAR_T_NEW=WTRRRVAR_T,
HYRSDATA_NEW=HYRSDATA,
HYPPROFILS_NEW=HYPPROFILS,
DE_VAR_T_NEW=DE_VAR_T,
DH_VAR_T_NEW=DH_VAR_T,
WEIGHT_S_NEW=WEIGHT_S,
WEIGHT_T_NEW=WEIGHT_T,
GMAXFS_NEW=GMAXFS
;

execute_unload  "../../base/auxils/timestep_conversion/output/DE_T.gdx", DE_T_NEW=DE_T;
execute_unload  "../../base/auxils/timestep_conversion/output/DH_T.gdx", DH_T_NEW=DH_T;
execute_unload  "../../base/auxils/timestep_conversion/output/GE_T.gdx", GE_T_NEW=GE_T;
execute_unload  "../../base/auxils/timestep_conversion/output/GH_T.gdx", GH_T_NEW=GH_T;
execute_unload  "../../base/auxils/timestep_conversion/output/GF_T.gdx", GF_T_NEW=GF_T;
execute_unload  "../../base/auxils/timestep_conversion/output/X_T.gdx", X_T_NEW=X_T;
execute_unload  "../../base/auxils/timestep_conversion/output/XH_T.gdx", XH_T_NEW=XH_T;
execute_unload  "../../base/auxils/timestep_conversion/output/ESTOVOLTS.gdx", ESTOVOLTS_NEW=ESTOVOLTS;
execute_unload  "../../base/auxils/timestep_conversion/output/HSTOVOLTS.gdx", HSTOVOLTS_NEW=HSTOVOLTS;
execute_unload  "../../base/auxils/timestep_conversion/output/ESTOVOLT.gdx", ESTOVOLT_NEW=ESTOVOLT;
execute_unload  "../../base/auxils/timestep_conversion/output/HSTOVOLT.gdx", HSTOVOLT_NEW=HSTOVOLT;
execute_unload  "../../base/auxils/timestep_conversion/output/ESTOLOADT.gdx", ESTOLOADT_NEW=ESTOLOADT;
execute_unload  "../../base/auxils/timestep_conversion/output/ESTOLOADTS.gdx", ESTOLOADTS_NEW=ESTOLOADTS;
execute_unload  "../../base/auxils/timestep_conversion/output/HSTOLOADT.gdx", HSTOLOADT_NEW=HSTOLOADT;
execute_unload  "../../base/auxils/timestep_conversion/output/HSTOLOADTS.gdx", HSTOLOADTS_NEW=HSTOLOADTS;
execute_unload  "../../base/auxils/timestep_conversion/output/ESTOVOLTSVAL.gdx", ESTOVOLTSVAL_NEW=ESTOVOLTSVAL;
execute_unload  "../../base/auxils/timestep_conversion/output/HSTOVOLTSVAL.gdx", HSTOVOLTSVAL_NEW=HSTOVOLTSVAL;
execute_unload  "../../base/auxils/timestep_conversion/output/ESTOVOLTVAL.gdx", ESTOVOLTVAL_NEW=ESTOVOLTVAL;
execute_unload  "../../base/auxils/timestep_conversion/output/HSTOVOLTVAL.gdx", HSTOVOLTVAL_NEW=HSTOVOLTVAL;
execute_unload  "../../base/auxils/timestep_conversion/output/HYRSG.gdx", HYRSG_NEW=HYRSG;
execute_unload  "../../base/auxils/timestep_conversion/output/VHYRS_SL.gdx", VHYRS_SL_NEW=VHYRS_SL;
execute_unload  "../../base/auxils/timestep_conversion/output/WATERVAL.gdx", WATERVAL_NEW=WATERVAL;
execute_unload  "../../base/auxils/timestep_conversion/output/GMAXFS.gdx", GMAXFS_NEW=GMAXFS;




*$ONTEXT
*WND_VAR_T timeseries
file WND_VAR_T_timeseries /'../../base/auxils/timestep_conversion/output/WND_VAR_T.inc'/;
WND_VAR_T_timeseries.nd  = 6;
put WND_VAR_T_timeseries;
put '*PARAMETER WND_VAR_T CALCULATED WITH AUXILS' //
loop((AAA,SSS_NEW,TTT_NEW)$WND_VAR_T_NEW(AAA,SSS_NEW,TTT_NEW),
            put "WND_VAR_T('",AAA.tl :0,"','",SSS_NEW.tl :0,"','",TTT_NEW.tl :0,"')=", WND_VAR_T_NEW(AAA,SSS_NEW,TTT_NEW) :0 ';' /
);
putclose;

*SOLE_VAR_T timeseries
file SOLE_VAR_T_timeseries /'../../base/auxils/timestep_conversion/output/SOLE_VAR_T.inc'/;
SOLE_VAR_T_timeseries.nd  = 6;
put SOLE_VAR_T_timeseries;
put '*PARAMETER SOLE_VAR_T CALCULATED WITH AUXILS' //
loop((AAA,SSS_NEW,TTT_NEW)$SOLE_VAR_T_NEW(AAA,SSS_NEW,TTT_NEW),
            put "SOLE_VAR_T('",AAA.tl :0,"','",SSS_NEW.tl :0,"','",TTT_NEW.tl :0,"')=", SOLE_VAR_T_NEW(AAA,SSS_NEW,TTT_NEW) :0 ';' /
);
putclose;

*SOLH_VAR_T timeseries
file SOLH_VAR_T_timeseries /'../../base/auxils/timestep_conversion/output/SOLH_VAR_T.inc'/;
SOLH_VAR_T_timeseries.nd  = 6;
put SOLH_VAR_T_timeseries;
put '*PARAMETER SOLH_VAR_T CALCULATED WITH AUXILS' //
loop((AAA,SSS_NEW,TTT_NEW)$SOLH_VAR_T_NEW(AAA,SSS_NEW,TTT_NEW),
            put "SOLH_VAR_T('",AAA.tl :0,"','",SSS_NEW.tl :0,"','",TTT_NEW.tl :0,"')=", SOLH_VAR_T_NEW(AAA,SSS_NEW,TTT_NEW) :0 ';' /
);
putclose;

*GKRATE timeseries
file GKRATE_timeseries /'../../base/auxils/timestep_conversion/output/GKRATE.inc'/;
GKRATE_timeseries.nd  = 6;
put GKRATE_timeseries;
put '*PARAMETER GKRATE CALCULATED WITH AUXILS' //
loop((AAA,GGG,SSS_NEW)$GKRATE_NEW(AAA,GGG,SSS_NEW),
            put "GKRATE('",AAA.tl :0,"','",GGG.tl :0,"','",SSS_NEW.tl :0,"')=", GKRATE_NEW(AAA,GGG,SSS_NEW) :0 ';' /
);
putclose;

*WTRRSVAR_S timeseries
file WTRRSVAR_S_timeseries /'../../base/auxils/timestep_conversion/output/WTRRSVAR_S.inc'/;
WTRRSVAR_S_timeseries.nd  = 6;
put WTRRSVAR_S_timeseries;
put '*PARAMETER WTRRSVAR_S CALCULATED WITH AUXILS' //
loop((AAA,SSS_NEW)$WTRRSVAR_S_NEW(AAA,SSS_NEW),
            put "WTRRSVAR_S('",AAA.tl :0,"','",SSS_NEW.tl :0,"')=", WTRRSVAR_S_NEW(AAA,SSS_NEW) :0 ';' /
);
putclose;

*WTRRRVAR_T timeseries
file WTRRRVAR_T_timeseries /'../../base/auxils/timestep_conversion/output/WTRRRVAR_T.inc'/;
WTRRRVAR_T_timeseries.nd  = 6;
put WTRRRVAR_T_timeseries;
put '*PARAMETER WTRRRVAR_T CALCULATED WITH AUXILS' //
loop((AAA,SSS_NEW,TTT_NEW)$WTRRRVAR_T_NEW(AAA,SSS_NEW,TTT_NEW),
            put "WTRRRVAR_T('",AAA.tl :0,"','",SSS_NEW.tl :0,"','",TTT_NEW.tl :0,"')=", WTRRRVAR_T_NEW(AAA,SSS_NEW,TTT_NEW) :0 ';' /
);
putclose;

*HYRSDATA timeseries
file HYRSDATA_timeseries /'../../base/auxils/timestep_conversion/output/HYRSDATA.inc'/;
HYRSDATA_timeseries.nd  = 6;
put HYRSDATA_timeseries;
put '*PARAMETER HYRSDATA CALCULATED WITH AUXILS' //
loop((AAA,HYRSDATASET,SSS_NEW)$HYRSDATA_NEW(AAA,HYRSDATASET,SSS_NEW),
            put "HYRSDATA('",AAA.tl :0,"','",HYRSDATASET.tl :0,"','",SSS_NEW.tl :0,"')=", HYRSDATA_NEW(AAA,HYRSDATASET,SSS_NEW) :0 ';' /
);
putclose;

*HYPPROFILS timeseries
file HYPPROFILS_timeseries /'../../base/auxils/timestep_conversion/output/HYPPROFILS.inc'/;
HYPPROFILS_timeseries.nd  = 6;
put HYPPROFILS_timeseries;
put '*PARAMETER HYPPROFILS CALCULATED WITH AUXILS' //
loop((AAA,SSS_NEW)$HYPPROFILS_NEW(AAA,SSS_NEW),
            put "HYPPROFILS('",AAA.tl :0,"','",SSS_NEW.tl :0,"')=", HYPPROFILS_NEW(AAA,SSS_NEW) :0 ';' /
);
putclose;

*DE_VAR_T timeseries
file DE_VAR_T_timeseries /'../../base/auxils/timestep_conversion/output/DE_VAR_T.inc'/;
DE_VAR_T_timeseries.nd  = 2;
put DE_VAR_T_timeseries;
put '*PARAMETER DE_VAR_T CALCULATED WITH AUXILS' //
loop((RRR,DEUSER,SSS_NEW,TTT_NEW)$DE_VAR_T_NEW(RRR,DEUSER,SSS_NEW,TTT_NEW),
            put "DE_VAR_T('",RRR.tl :0,"','",DEUSER.tl :0,"','",SSS_NEW.tl :0,"','",TTT_NEW.tl :0,"')=", DE_VAR_T_NEW(RRR,DEUSER,SSS_NEW,TTT_NEW) :0 ';' /
);
putclose;

*DH_VAR_T timeseries
file DH_VAR_T_timeseries /'../../base/auxils/timestep_conversion/output/DH_VAR_T.inc'/;
DH_VAR_T_timeseries.nd  = 2;
put DH_VAR_T_timeseries;
put '*PARAMETER DH_VAR_T CALCULATED WITH AUXILS' //
loop((AAA,DHUSER,SSS_NEW,TTT_NEW)$DH_VAR_T_NEW(AAA,DHUSER,SSS_NEW,TTT_NEW),
            put "DH_VAR_T('",AAA.tl :0,"','",DHUSER.tl :0,"','",SSS_NEW.tl :0,"','",TTT_NEW.tl :0,"')=", DH_VAR_T_NEW(AAA,DHUSER,SSS_NEW,TTT_NEW) :0 ';' /
);
putclose;

*WEIGHT_S timeseries
file WEIGHT_S_timeseries /'../../base/auxils/timestep_conversion/output/WEIGHT_S.inc'/;
WEIGHT_S_timeseries.nd  = 7;
put WEIGHT_S_timeseries;
put '*PARAMETER WEIGHT_S CALCULATED WITH AUXILS' //
loop(SSS_NEW,
            put "WEIGHT_S('",SSS_NEW.tl :0,"')=", WEIGHT_S_NEW(SSS_NEW) :0 ';' /
);
putclose;

*WEIGHT_T timeseries
file WEIGHT_T_timeseries /'../../base/auxils/timestep_conversion/output/WEIGHT_T.inc'/;
WEIGHT_T_timeseries.nd  = 7;
put WEIGHT_T_timeseries;
put '*PARAMETER WEIGHT_T CALCULATED WITH AUXILS' //
loop(TTT_NEW,
            put "WEIGHT_T('",TTT_NEW.tl :0,"')=", WEIGHT_T_NEW(TTT_NEW) :0 ';' /
);
putclose;



*$OFFTEXT
*------------END OF OUTPUT GENERATION-------------
