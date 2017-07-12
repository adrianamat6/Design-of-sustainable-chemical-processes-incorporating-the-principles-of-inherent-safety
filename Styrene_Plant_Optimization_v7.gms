
*Option for the display statement to print 8 decimals
option decimals=8;


SETS
I i is organic components /Benz, Tol, EBenz, Sty /
m streams    /1*11/
j components /EB, Sty, H2, Ethy, Tol, CO, CO2, CH4, H2O, Benz /
w reactions  /R1, R2, R3, R4, R5, R6 /
e equiment   /Reactor, Cooler, Column1, Column2/

p purchased CAPEX /Vessel, Cooler, Tower1, Tower2, Tray1, Tray2, Condenser1,
              Condenser2, Reboiler1, Reboiler2 /


R r is Underwood root  /r1*r3/
C c is a column (separation task) /Tol_EBenz, EBenz_Sty/
s secciones de columna /s1, s2/




active_root(c,r) active Underwood root


 alias (i,t)
;


* Set the active root
 active_root('Tol_EBenz','r2') = YES;
 active_root('EBenz_Sty','r3') = YES;

PARAMETERS
 RECOVERY(c,i)  mole flowrate ratio between distillate to feed stream for component i in column c
 RECOVERY_LK(c) mole flowrate ratio distillate to feed stream for light key component in column c
* RECOVERY_BOTTOMS(c,i)  mole flowrate ratio bottoms to feed stream for component i in column c
 RECOVERY_BOTTOMS_HK(c) mole flowrate ratio bottoms to feed stream for heavy key component in column c

 LK(c) position for the light key component in column c
 HK(c) position for the heavy key component in column c

;
* Column 1
 LK('Tol_EBenz') = 2;
 HK('Tol_EBenz') = 3;

* Column 2
 LK('EBenz_Sty') = 3;
 HK('EBenz_Sty') = 4;



PARAMETERS
p00(w)  /R1 2.07,     R2  0.104,    R3  0.1411,    R4  0.06923 ,    R5  0.07666 ,   R6  0.2123     /
p10(w)  /R1 -0.04086, R2  0.007523, R3  0.04501,   R4  0.00959 ,    R5  0.045534 ,  R6  0.06483    /
p01(w)  /R1 0.3563,   R2  0.04236,  R3  -0.002272, R4  -0.001204  , R5  -0.006209 , R6   -0.008879 /


factor_3_phase_separator_factor_4(j)    factor which multiply molar balance in efluent 4
        /EB 0, Sty 0, H2 1, Ethy  1, Tol  0, CO  1, CO2  1, CH4   1, H2O  0, Benz 0/
factor_3_phase_separator_factor_5(j)    factor which multiply molar balance in efluent 5
        /EB 0, Sty 0, H2 0, Ethy  0, Tol  0, CO  0, CO2  0, CH4   0, H2O  1, Benz 0/
factor_3_phase_separator_factor_6(j)    factor which multiply molar balance in efluent 6
        /EB 1, Sty 1, H2 0, Ethy  0, Tol  1, CO  0, CO2  0, CH4   0, H2O  0, Benz 1/
factor_column1_distillate(j)            factor which multiply molar balance in efluent 8
        /EB 0.005, Sty 0, H2 0, Ethy  0, Tol  0.995, CO  0, CO2  0, CH4   0, H2O  0, Benz 1/
factor_column1_bottom(j)                factor which multiply molar balance in efluent 9
        /EB 0.995, Sty 1, H2 0, Ethy  0, Tol  0.005, CO  0, CO2  0, CH4   0, H2O  0, Benz 0/
factor_column2_distillate(j)            factor which multiply molar balance in efluent 10
        /EB 0, Sty 0, H2 0, Ethy  0, Tol  0.001, CO  0, CO2  0, CH4   0, H2O  0, Benz 0.999/
factor_column2_bottom(j)                 factor which multiply molar balance in efluent 11
        /EB 1, Sty 0, H2 0, Ethy  0, Tol  0.999, CO  0, CO2  0, CH4   0, H2O  0, Benz 0.001/
factor_column3_distillate(j)             factor which multiply molar balance in efluent 12
        /EB 0.997, Sty 0.003, H2 0, Ethy  0, Tol  1, CO  0, CO2  0, CH4   0, H2O  0, Benz 0/
factor_column3_bottom(j)                 factor which multiply molar balance in efluent 13
        /EB 0.003, Sty 0.997, H2 0, Ethy  0, Tol  0, CO  0, CO2  0, CH4   0, H2O  0, Benz 0/

;


TABLE  alpha(c,i) relative volatility for component i in column c

               Benz          Tol           EBenz          Sty
Tol_EBenz     7.2557262     2.4049244     1.55383517       1
EBenz_Sty     5.3263        2.66089       1.23397          1
* 16.5  10.5  9.04  5.74  5.10 2.92  1.70  1.00

;

TABLE  stoichiometric(w,j)
       EB      Sty      H2  Ethy        Tol     CO    CO2     CH4    H2O     Benz
R1     -1        1      1     0          0       0     0       0      0        0
R2     -1        0      0     1          0       0     0       0      0        1
R3     -1        0     -1     0          1       0     0       1      0        0
R4      0        0      4    -1          0       2     0       0     -2        0
R5      0        0      3     0          0       1     0      -1     -1        0
R6      0        0      1     0          0      -1     1       0     -1        0        ;


* Column 1
 RECOVERY_LK('Tol_EBenz') = 0.995  ;
 RECOVERY_BOTTOMS_HK('Tol_EBenz') = 0.995 ;

* Column 2
 RECOVERY_LK('EBenz_Sty') = 0.997  ;
 RECOVERY_BOTTOMS_HK('EBenz_Sty') = 0.997 ;


*(c$(ord(c)),
    RECOVERY(c,i)$(ord(i) < LK(c) ) = 1;
    RECOVERY(c,i)$(ord(i) = LK(c) ) = RECOVERY_LK(c);
    RECOVERY(c,i)$(ord(i) = HK(c) ) = 1 - RECOVERY_BOTTOMS_HK(c);
    RECOVERY(c,i)$(ord(i) > HK(c) ) = 0;
*);

 display recovery;



POSITIVE VARIABLES

temperature(m)                temperature of each efluent (i)  [ºC]
molarFlowComponent(j,m)       molar flowrate of each component j in each efluent i [kmol·h^-1]
pressure(m)                   pressure of each efluent(i)      [bar]
reactionExtent(w)             extent of reaction r             [kmol·h^-1]
Length(e)                     length of equipments e           [m]

* Columns
 V1(c)    vapor mole flowrate in the enriching section
 V2(c)    vapor mole flowrate in the exhausting section
 L1(c)    liquid mole flowrate in the enriching section
 L2(c)    liquid mole flowrate in the exhausting section
 F(c)     total mole flowrate in the feed stream
 D(c)     total mole flowrate in the distillate stream
 B(c)     total mole flowrate in the bottom stream
 Fi(c,i) mole flowrate for component i in the feed stream [kmol·h^{-1}]
 Di(c,i) mole flowrate for component i in the distillate stream
 Bi(c,i) mole flowrate for component i in the bottom stream
 root_UW(c,r) Underwood root for a given separation task
* Nmin(c)   Minimum number of stages

;

VARIABLES
 objfunValue
;

EQUATIONS
* SPECIFIC MOLAR BALANCES IN DISTILLATION COLUMNS
FEED_COLUMN1_EBENZENE
FEED_COLUMN1_STYRENE
FEED_COLUMN1_TOLUENE
FEED_COLUMN1_BENZENE


* COLUMNS_ BALANCES
COMPONENT_MOLE_BALANCE
TOTAL_MOLE_BALANCE
TOP_TOTAL_MOLE_BALANCE
BOTTOM_TOTAL_MOLE_BALANCE
FEED_TOTAL_MOLE_BALANCE
THERMAL_CONDITION_OF_THE_FEED
TOTAL_COMPONENT_RELATION_FEED
TOTAL_COMPONENT_RELATION_DISTILLATE
TOTAL_COMPONENT_RELATION_BOTTOM
UNDERWOOD_1
UNDERWOOD_2
UNDERWOOD_3
COMPONENT_RECOVERY_IN_DISTILLATE
FEED_COLUMN2
TOTAL_FEED_COLUMN2



* MOLAR, ENERGY AND MOMENTUM BALANCES IN EQUIPMENT

INITIAL_TEMPERATURE
INITIAL_PRESSURE
MOLAR_BALANCE_REACTOR
EXTENT_OF_REACTIONS
ENERGY_BALANCE_REACTOR
MOMENTUM_BALANCE_REACTOR
MOLAR_BALANCE_COOLER
ENERGY_BALANCE_COOLER
MOMENTUM_BALANCE_COOLER
MOLAR_BALANCE_THREE_PHASE_SEPARATOR_4
MOLAR_BALANCE_THREE_PHASE_SEPARATOR_5
MOLAR_BALANCE_THREE_PHASE_SEPARATOR_6
ENERGY_BALANCE_THREE_PHASE_SEPARATOR_4
ENERGY_BALANCE_THREE_PHASE_SEPARATOR_5
ENERGY_BALANCE_THREE_PHASE_SEPARATOR_6
MOMENTUM_BALANCE_THREE_PHASE_SEPARATOR_4
MOMENTUM_BALANCE_THREE_PHASE_SEPARATOR_5
MOMENTUM_BALANCE_THREE_PHASE_SEPARATOR_6
MOLAR_BALANCE_PUMP
ENERGY_BALANCE_PUMP
MOMENTUM_BALANCE_PUMP
MOLAR_BALANCE_COLUMN1_DISTILLATE
ENERGY_BALANCE_COLUMN1_DISTILLATE
MOMENTUM_BALANCE_COLUMN1_DISTILLATE
MOLAR_BALANCE_COLUMN1_BOTTOM
ENERGY_BALANCE_COLUMN1_BOTTOM
MOMENTUM_BALANCE_COLUMN1_BOTTOM
MOLAR_BALANCE_COLUMN3_DISTILLATE
ENERGY_BALANCE_COLUMN3_DISTILLATE
MOMENTUM_BALANCE_COLUMN3_DISTILLATE
MOLAR_BALANCE_COLUMN3_BOTTOM
ENERGY_BALANCE_COLUMN3_BOTTOM
MOMENTUM_BALANCE_COLUMN3_BOTTOM




OBJECTIVE_FUNCTION
INPUT_WATER_REACTOR
MOLAR_LENGTH_CONTRAINT




*MINIMUM_NUMBER_STAGES
;

* =============================================================================

* SPECIFIC MOLAR BALANCES IN DISTILLATION COLUMNS
FEED_COLUMN1_EBENZENE..
Fi('Tol_EBenz','EBenz') =E= molarFlowComponent('EB','7')
;

FEED_COLUMN1_STYRENE..
Fi('Tol_EBenz','Sty')   =E= molarFlowComponent('Sty','7')
;

FEED_COLUMN1_TOLUENE..
Fi('Tol_EBenz','Tol')   =E= molarFlowComponent('Tol','7')
;

FEED_COLUMN1_BENZENE..
Fi('Tol_EBenz','Benz')  =E= molarFlowComponent('Benz','7')
;

* ===============================================================================

* COLUMNS
COMPONENT_MOLE_BALANCE(c,i)..
    Fi(c,i) =E= Di(c,i) + Bi(c,i)
;

TOTAL_MOLE_BALANCE(c)..
    F(c) =E= D(c) + B(c)
;

TOP_TOTAL_MOLE_BALANCE(c)..
    V1(c) =E= D(c) + L1(c)
;

BOTTOM_TOTAL_MOLE_BALANCE(c)..
    L2(c) =E= V2(c) + B(c)
;

FEED_TOTAL_MOLE_BALANCE(c)..
    F(c) + L1(c) + V2(c) =E= V1(c) + L2(c)
;

THERMAL_CONDITION_OF_THE_FEED(c)..
    V1(c) =E= V2(c)
;

TOTAL_COMPONENT_RELATION_FEED(c)..
    F(c) =E= sum(i, Fi(c,i))
;

TOTAL_COMPONENT_RELATION_DISTILLATE(c)..
    D(c) =E= sum(i, Di(c,i))
;

TOTAL_COMPONENT_RELATION_BOTTOM(c)..
    B(c) =E= sum(i, Bi(c,i))
;

UNDERWOOD_1(active_root(c,r))..
    sum(i, alpha(c,i) * Fi(c,i) / (alpha(c,i) - root_UW(c,r)) ) =E= V1(c) - V2(c)
;

UNDERWOOD_2(active_root(c,r))..
    sum(i, alpha(c,i) * Di(c,i) /(alpha(c,i) - root_UW(c,r)) ) =L= V1(c)
;

UNDERWOOD_3(active_root(c,r))..
    sum(i, alpha(c,i) * Bi(c,i) / (alpha(c,i) - root_UW(c,r))) =G= -V2(c)
;



* Force component mole flowrate at the at bottoma and distillate according to the given recovery

COMPONENT_RECOVERY_IN_DISTILLATE(c,i)$(ord(i) <= LK(c) OR ord(i) >= HK(c) )..
    Di(c,i) =E= RECOVERY(c,i)*Fi(c,i)
;




FEED_COLUMN2(i)..
    Fi('EBenz_Sty',i) =E= Bi('Tol_EBenz',i)
;

TOTAL_FEED_COLUMN2..
    F('EBenz_Sty') =E= B('Tol_EBenz')
;



* ===============================================================================


* MOLAR, ENERGY AND MOMENTUM BALANCES IN EQUIPMENT

* REACTOR  BALANCES
INITIAL_TEMPERATURE..
temperature('1') =E= 700
;
INITIAL_PRESSURE..
pressure('1') =E= 1.6
;

MOLAR_BALANCE_REACTOR(j)..
molarFlowComponent(j,'2') =E= molarFlowComponent(j,'1') + sum(w, stoichiometric(w,j) * reactionExtent(w) )
;

EXTENT_OF_REACTIONS(w)..
reactionExtent(w) =E= p00(w) + p10(w) * Length('reactor') +  p01(w) * molarFlowComponent('EB','1') ;
;

ENERGY_BALANCE_REACTOR..
temperature('2') =E= 576.5 - 1.148 * Length('reactor') + 2.147 * molarFlowComponent('EB','1')
;

MOMENTUM_BALANCE_REACTOR..
pressure('2') =E= 1.991 - 0.1069 * Length('reactor') - 0.04344 * molarFlowComponent('EB','1')
;


*COOLER BALANCES
MOLAR_BALANCE_COOLER(j)..
molarFlowComponent(j,'2') =E= molarFlowComponent(j,'3')
;

ENERGY_BALANCE_COOLER..
temperature('3') =E= 30
;

MOMENTUM_BALANCE_COOLER..
pressure('3') =E= pressure('2')-0.1
;

*THREE PHASE SEPARATOR BALANCES
MOLAR_BALANCE_THREE_PHASE_SEPARATOR_4(j)..
molarFlowComponent(j,'4') =E= molarFlowComponent(j,'3') * factor_3_phase_separator_factor_4(j)
;

MOLAR_BALANCE_THREE_PHASE_SEPARATOR_5(j)..
molarFlowComponent(j,'5') =E= molarFlowComponent(j,'3') * factor_3_phase_separator_factor_5(j)
;

MOLAR_BALANCE_THREE_PHASE_SEPARATOR_6(j)..
molarFlowComponent(j,'6') =E= molarFlowComponent(j,'3') * factor_3_phase_separator_factor_6(j)
;

ENERGY_BALANCE_THREE_PHASE_SEPARATOR_4..
temperature('4') =E= temperature('3')
;

ENERGY_BALANCE_THREE_PHASE_SEPARATOR_5..
temperature('5') =E= temperature('3')
;

ENERGY_BALANCE_THREE_PHASE_SEPARATOR_6..
temperature('6') =E= temperature('3')
;


MOMENTUM_BALANCE_THREE_PHASE_SEPARATOR_4..
pressure('4') =E= pressure('3')
;

MOMENTUM_BALANCE_THREE_PHASE_SEPARATOR_5..
pressure('5') =E= pressure('3')
;

MOMENTUM_BALANCE_THREE_PHASE_SEPARATOR_6..
pressure('6') =E= pressure('3')
;



*PUMP BALANCES
MOLAR_BALANCE_PUMP(j)..
molarFlowComponent(j,'7') =E= molarFlowComponent(j,'6')
;

ENERGY_BALANCE_PUMP..
temperature('7') =E= 30
;

MOMENTUM_BALANCE_PUMP..
pressure('7') =E= 1.026
;




* COLUMN 1 BALANCES
MOLAR_BALANCE_COLUMN1_DISTILLATE(j)..
molarFlowComponent(j,'8') =E= molarFlowComponent(j,'7') * factor_column1_distillate(j)
;

ENERGY_BALANCE_COLUMN1_DISTILLATE..
temperature('8') =E= 93.02
;

MOMENTUM_BALANCE_COLUMN1_DISTILLATE..
pressure('8') =E= 0.932
;

MOLAR_BALANCE_COLUMN1_BOTTOM(j)..
molarFlowComponent(j,'9') =E= molarFlowComponent(j,'7') * factor_column1_bottom(j)
;

ENERGY_BALANCE_COLUMN1_BOTTOM..
temperature('9') =E= 117.4
;

MOMENTUM_BALANCE_COLUMN1_BOTTOM..
pressure('9') =E= 1.026
;


* COLUMN 2 BALANCES
MOLAR_BALANCE_COLUMN3_DISTILLATE(j)..
molarFlowComponent(j,'10') =E= molarFlowComponent(j,'9') * factor_column3_distillate(j)
;

ENERGY_BALANCE_COLUMN3_DISTILLATE..
temperature('10') =E= 89.9
;

MOMENTUM_BALANCE_COLUMN3_DISTILLATE..
pressure('10') =E= 0.2464
;

MOLAR_BALANCE_COLUMN3_BOTTOM(j)..
molarFlowComponent(j,'11') =E= molarFlowComponent(j,'9') * factor_column3_bottom(j)
;

ENERGY_BALANCE_COLUMN3_BOTTOM..
temperature('11') =E= 122.4
;

MOMENTUM_BALANCE_COLUMN3_BOTTOM..
pressure('11') =E= 0.5264
;

OBJECTIVE_FUNCTION..
         objfunValue =E= V1('Tol_EBenz')
;


* ==============================================================================

INPUT_WATER_REACTOR..
molarFlowComponent('H2O','1') =E= (106.17 * 2 / 18.01528 ) *  molarFlowComponent('EB','1')
;

MOLAR_LENGTH_CONTRAINT..
Length('Reactor') =L= -0.4 * molarFlowComponent('EB','1') + 10
*molarFlowComponent('EB','1') =G= 25 * Length('Reactor') - 70
;



* ================================================================================

*MINIMUM_NUMBER_STAGES..



model oneColum / all /
;


loop( (c,r,i)$(ord(i) = ord(r)),
             root_UW.up(c,r) = alpha(c,i)  - 0.01;

    );

loop( (c,r,i)$(ord(i) = ord(r)+1 ),
             root_UW.lo(c,r) = alpha(c,i)  + 0.01;
    );





*molarFlowComponent.fx('EB','1')=14.25  ;
molarFlowComponent.fx('Sty','1')= 0;
molarFlowComponent.fx('H2','1')=0 ;
molarFlowComponent.fx('Ethy','1')= 0 ;
molarFlowComponent.fx('Tol','1')=0;
molarFlowComponent.fx('CO','1')=0;
molarFlowComponent.fx('CO2','1')=0;
molarFlowComponent.fx('CH4','1')=0;
*molarFlowComponent.fx('H2O','1')=170.42;
molarFlowComponent.fx('Benz','1')=0;


molarFlowComponent.up('EB','1')=30  ;
molarFlowComponent.lo('EB','1')=5   ;

Length.lo('reactor') = 2  ;
Length.up('reactor') = 10 ;


display root_UW.up,root_UW.lo;

root_UW.l(c,r) = (root_UW.lo(c,r) + root_UW.up(c,r))/2;


solve oneColum using NLP min objfunValue
;


display Fi.l, Di.l, Bi.l ;


PARAMETER
Nmin(c)   minimum number of stages
SepPisos  trays separation  [m]
;
* Nmin=1;
 Nmin(c) = sum((i,t)$(ord(i) = LK(c) and ord(t) = HK(c)),
          log(  RECOVERY_LK(c)         / ( 1-RECOVERY_LK(c) )
              * RECOVERY_BOTTOMS_HK(c) / ( 1-RECOVERY_BOTTOMS_HK(c) ) )
              / log( alpha(c,i) / alpha(c,t) )
               );

SepPisos = 0.6096;

display Nmin;

POSITIVE VARIABLES

         a       Numero de veces por encima del reflujo minimo (ej 1.2 veces el minimo)
         Rmin    Reflujo minimo
         NP(c)   Numero de pisos reales
         X(c)    variable auxiliar ver comentarios previos
         H(c,s)    altura de la seccion de columna

         NS(c,s)  Pisos en cada seccion
         ;


         a.lo = 1.01;
         NP.lo(c) = Nmin(c) + 0.0001;
         X.lo(c) = 0.00000001;


EQUATIONS
         pisos01, Pisos02, pisos03, pisos04, pisos05, pisos06, pisos07;

pisos01(c)..  (NP(c) - Nmin(c))/(NP(c) + 1) =E=
               1 - exp(
                        ( 1+ 54.4*X(c))/(11+117.2*X(c)) * (X(c)-1)/sqrt(X(c))
                        ) ;

pisos02(c).. X(c) =E= Rmin(c)*(a-1)/(a*Rmin(c)+1);

pisos03(c)..  Rmin(c)*D(c) =E= L1(c);

pisos04(c)..     NS(c,'s1') * (sum(i$(ord(i) = HK(c)), Fi(c,i))  )=E= NS(c,'s2')*(sum(i$(ord(i) = LK(c)), Fi(c,i)) * D(c)/(B(c)+ 1e-6))**0.206;

pisos05(c)..     NP(c) =E= NS(c,'s1') + NS(c,'s2');


pisos06(c)..  H(c,'s1') =E= SepPisos*(NS(c,'s1') - 1) + 1.5;
pisos07(c)..  H(c,'s2') =E= SepPisos*(NS(c,'s2')) + 1.5;


SCALAR
         rol "densidad media del liquido kg/m3" /895.222011789494 /
         rov " densidad media del vapor" /38/
         rol2 "densidad media del liquido kg/m3" /811.003743700133/
         rov2 " densidad media del vapor" /35/
*         NOTA: el producto rol*rov varia en las peores condiciones un 8% como máximo (comprobado con HYSYS).
*               se pueden utilizar estos valores medios sin demasiado error para un diseño preliminar
*                Presion de operacion 1 atm.

         Mv Peso molecular medio se calcula en las condiciones de alimento /102.056346288162 /
*                Se puede afinar y calcular el diámetro en las condiciones de alimentacion a cada columna por ejemplo.

POSITIVE VARIABLE

         AreaColumn(c,s);


EQUATIONS
         ec01, ec02 ;

*ec01(c)..       Area(c,'s1') =E= Mv/(rol*rov)**0.5* 1/0.7 * 1/439 * 1/0.8 * (V1(c) + L1('c2')*(a-1));
*ec02(c)..       Area(c,'s2') =E= Mv/(rol*rov)**0.5* 1/0.7 * 1/439 * 1/0.8 * (V2(c) + L1('c2')*(a-1));

ec01(c)..       AreaColumn(c,'s1') =E= Mv/(rol*rov)**0.5* 1/0.7 * 1/439 * 1/0.8 * (V1(c) + L1(c)*(a-1));
ec02(c)..       AreaColumn(c,'s2') =E= Mv/(rol*rov)**0.5* 1/0.7 * 1/439 * 1/0.8 * (V2(c) + L1(c)*(a-1));

PARAMETERS
 DHvap(i)  "kJ/kmol"
 /
   Benz   30970.600197494
   Tol    333358.5514600167
   EBenz  35754.7740996288
   Sty    37228.6166554207
 /;

POSITIVE VARIABLES
         Qreb(c)     kW
         Qcond(c)    kW ;


EQUATIONS
         heat01, heat02;

heat01(c)..
    Qcond(c) * D(c)*(V1(c)+ L1(c)*(a-1))/3600 =E= sum(i, Di(c,i)*DHvap(i)) ;
;
heat02(c)..
    Qreb(c) * B(c)*(V2(c)+ L1(c)*(a-1))/3600  =E= sum(i, Bi(c,i)*DHvap(i)) ;

*Area_column_s1..
AreaColumn.lo('Tol_EBenz','s1')= 0.1642 ;
AreaColumn.lo('EBenz_Sty','s1')= 0.1642 ;

AreaColumn.up('Tol_EBenz','s1')= 12;
AreaColumn.up('EBenz_Sty','s1')= 12;

*Area_column_s2..
AreaColumn.lo('Tol_EBenz','s2')= 0.1641 ;
AreaColumn.lo('EBenz_Sty','s2')= 0.1641 ;

AreaColumn.up('Tol_EBenz','s2')= 12 ;
AreaColumn.up('EBenz_Sty','s2')= 12 ;


PARAMETERS
         DTMLCond(c)  ºC   /Tol_EBenz 42.055 , EBenz_Sty 87.9052 /
         DTMLReb(c)   ºC   /Tol_EBenz 21.5   , EBenz_Sty  37.9/
SCALAR
         Ureb     "kW/m2/K"  /0.8/
         Ucond    "kW/m2/K"  /0.8/

;
POSITIVE VARIABLES
      AreaCond(c)
      AreaReb(c) ;

EQUATIONS
         Cambcal01, Cambcal02;



Cambcal01(c)..    Qreb(c)  =E= Ureb*AreaReb(c)*DTMLReb(c);
Cambcal02(c)..    QCond(c) =E= Ucond*AreaCond(c)*DTMLCond(c);




* ===========================================================================================================
* =============================================================================================================
* SAFETY


PARAMETER
deltaCombustionComponent(j)   heat of combustion of components j [BTU·lb^-1]
/EB 17.6e3, Sty 17.4e3, H2  51.6e3, Ethy 20.8e3,Tol 17.4e3,
CO 4.3e3,CO2 0, CH4 21.5e3, H2O 0, Benz 17.3e3 /


molecularWeight(j)     molecular weight of components j [kg·kmol^-1]
/EB  106 ,Sty    104.15, H2   2 ,Ethy   25.05 , Tol   92.14,
CO  28.01,CO2  44.01,CH4  16.04, H2O  18 , Benz   78.11/


heatCapacity(j)       heat capacity of components j   [kJ·kg^-1·ºC^-1]
/EB 2.248,Sty   2.172,H2   14.51, Ethy  2.386, Tol    2.161,
CO 1.097, CO2 0.7766, CH4 3.216, H2O  3.3137 ,Benz  2.083/

DensityOrganicComponent(I) density of organic components in columns [kg·m3^-1]
/Benz   876, Tol    867, Ebenz  866, Sty   909 /

;

POSITIVE VARIABLES
Area(e)                       area of equipment e   [m2]
Volume(e)                     volume of equipment e [m3]
column1Diameter               diameter of column 1  [m]
column2Diameter               diameter of column 2  [m]
column3Diameter               diameter of column 3  [m]


coolerQ                         heat dissipated by cooler [kJ·h^-1]
coolerdeltaTml                  Logarithmic mean temperature difference in cooler [ºC]
massFlowComponent(j,m)          mass flowrate of each component j in each efluent i [kg·h^-1]



FireExplosionIndex            fire & explosion index
penaltyE2                     penalty due to relief pressure
pentalyG2                     penalty due to quantity of flammable or unstable material
penaltyYoperation             penalty due to operating pressure in equipments [bar]
penaltyYrelief                penalty due to realive pressure in equipments   [bar]
pressureOperationEquipment    pressure operation  in equipments  [bar]
totalBTUinProcess             Total BTU in process  [BTU]
concentrationComponent(j,e)   concentration component j in equipment e (lb·m3^-1)

averageMassFlowComponent(j,e)   average molar flowrate of each component j in each equipment e [lb·h^-1]
averageMolarFlowComponent(j,e)  average molar flowrate of each component j in each equipment e [kmol·h^-1]
averageReactionExtent(w)        average extent of reaction r [kmol·h^-1]
density(e)                      density in each equipmente e [kg·m3^-1]
averagePressure(e)              average pressure of each equipment [Pa]
averageMolecularWeight(e)       average molecular weight in each equipment [g·mol^-1]
averageTemperature(e)           average temperature in each equipment [K]
massFraction(j,e)               mass fraction of each component j in the equipment e
volumetricFlow(e)               average volumentric flow of each equipment e [m3·h^-1]
MassFlow
volumetricFlowComponent(m)      volumetric flowrate os each stream i [m3·h^-1]
totalMolarFlow(m)               total molar flowrate of each stream i [kmol·h^-1]
volumetricFlowVapor             vapor volumetric flowrate   [m^3·h^-1]
volumetricFlowOrganic           organic volumetric flowrate [m^3·h^-1]
volumetricFlowWater             water volumetric flowrate   [m^3·h^-1]
massFractionOrganic3(I)
density3
density9
massFractionOrganic9(i)
;
SCALARS
reactorDiameter               reactor diameter [m]  /1.95/
CoolerSection                 cooler  section  [m2] /0.1963/
coolerU                       overall coeficient of heat transfer (cooler and condenser) [kJ·h^-1·ºC^-1]  /2880/
heaterU                       overall coeficient of heat transfer (reboiler) [kJ·h^-1·ºC^-1]  /2880/
coolerTubes                   number of tubes in the cooler  /15/
trayspacingColumn             spacing between trays in columns [m]  /0.6096/
Rgases                        constant of ideal gases   [J·mol^-1·K^-1]  /8.31/
spillDuration                 duration of spill [h]  /0.1666667/
inc_T_cond1                   logarithmic mean temperature difference in condenser 1 / 43.1069 /
inc_T_cond2                   logarithmic mean temperature difference in condenser 2 / 35.3143 /
inc_T_cond3                   logarithmic mean temperature difference in condenser 3 / 54.7479 /
inc_T_reb1                    logarithmic mean temperature difference in reboiler  1 / 42.6    /
inc_T_reb2                    logarithmic mean temperature difference in reboiler  2 / 52.2    /
inc_T_reb3                    logarithmic mean temperature difference in reboiler  3 / 37.9    /
YEAR                          hours in a year each equipment work [hr·yr^-1]    /8000/
WATER                         water cost (utility)  [$·kW^-1·h^-1]              / 0.0013 /
STEAM                         steam cost (utility)  [$·kW^-1·h^-1]              / 0.0506 /
annualizationFactor           annualization factor                              /0.1874  /
Rgas                          ideal gases constant    [kJ·kmol^-1·K^-1]         /8.31    /


EQUATIONS
*SAFETY
DOWS_FIRE_EXPLOSION_INDEX
PENALTY_E2
PENALTY_Y_OPERATION_E2
PENALTY_Y_RELIEF_E2
PRESSURE_OPERATION_EQUIPMENT_E2_REACTOR
PRESSURE_OPERATION_EQUIPMENT_E2_COOLER
PRESSURE_OPERATION_EQUIPMENT_E2_COLUMN_1
PRESSURE_OPERATION_EQUIPMENT_E2_COLUMN_2
*PRESSURE_OPERATION_EQUIPMENT_E2_COLUMN_3
PENALTY_G2
TOTAL_BTU_IN_PROCESS_REACTOR_VOLUME
TOTAL_BTU_IN_PROCESS_COOLER_VOLUME
TOTAL_BTU_IN_PROCESS_COLUMN1_VOLUME
TOTAL_BTU_IN_PROCESS_COLUMN2_VOLUME
*TOTAL_BTU_IN_PROCESS_COLUMN3_VOLUME
TOTAL_BTU_IN_PROCESS_REACTOR_SPILL
TOTAL_BTU_IN_PROCESS_COOLER_SPILL
TOTAL_BTU_IN_PROCESS_COLUMN1_SPILL
TOTAL_BTU_IN_PROCESS_COLUMN2_SPILL
*TOTAL_BTU_IN_PROCESS_COLUMN3_SPILL
MASS_FLOW_COMPONENT
;

*SAFETY

DOWS_FIRE_EXPLOSION_INDEX..
FireExplosionIndex =E=  128.52 + 40.8 * (penaltyE2 + pentalyG2)
;

PENALTY_E2..
penaltyE2 * penaltyYrelief =E=  POWER(penaltyYoperation,2)
;

PENALTY_Y_OPERATION_E2..
penaltyYoperation =E= 0.02254 * pressureOperationEquipment + 0.1615
;

PENALTY_Y_RELIEF_E2..
penaltyYrelief =E= 0.02254 * (pressureOperationEquipment * 1.2) + 0.1615
;

PRESSURE_OPERATION_EQUIPMENT_E2_REACTOR..
pressureOperationEquipment =G= ( pressure('1') + pressure('2') ) / 2
;

PRESSURE_OPERATION_EQUIPMENT_E2_COOLER..
pressureOperationEquipment =G= ( pressure('2') + pressure('3') ) / 2
;

PRESSURE_OPERATION_EQUIPMENT_E2_COLUMN_1..
pressureOperationEquipment =G= pressure('7')
;

PRESSURE_OPERATION_EQUIPMENT_E2_COLUMN_2..
pressureOperationEquipment =G= pressure('9')
;

*PRESSURE_OPERATION_EQUIPMENT_E2_COLUMN_3..
*pressureOperationEquipment =G= pressure('9')
*;

PENALTY_G2..
pentalyG2 * (totalBTUinProcess *1e-9 + 0.6932) =E=  (2.509 * totalBTUinProcess*1e-9 + 0.01545)
;

TOTAL_BTU_IN_PROCESS_REACTOR_VOLUME..
totalBTUinProcess =G= Volume('Reactor') * sum(j, concentrationComponent(j,'Reactor') *  deltaCombustionComponent(j) )
;

TOTAL_BTU_IN_PROCESS_COOLER_VOLUME..
totalBTUinProcess =G= Volume('Cooler') * sum(j, concentrationComponent(j,'Cooler') * deltaCombustionComponent(j) )
;

TOTAL_BTU_IN_PROCESS_COLUMN1_VOLUME..
totalBTUinProcess =G= Volume('Column1') * sum(j, concentrationComponent(j,'Column1') * deltaCombustionComponent(j) )
;

TOTAL_BTU_IN_PROCESS_COLUMN2_VOLUME..
totalBTUinProcess =G= Volume('Column2') * sum(j, concentrationComponent(j,'Column2') * deltaCombustionComponent(j) )
;

*TOTAL_BTU_IN_PROCESS_COLUMN3_VOLUME..
*totalBTUinProcess =G= Volume('Column3') * sum(j, concentrationComponent(j,'Column3') * deltaCombustionComponent(j) )
*;

TOTAL_BTU_IN_PROCESS_REACTOR_SPILL..
totalBTUinProcess =G=   sum(j, deltaCombustionComponent(j) * massFlowComponent(j,'1') * 2.20462 ) * spillDuration
;

TOTAL_BTU_IN_PROCESS_COOLER_SPILL..
totalBTUinProcess =G=   sum(j, deltaCombustionComponent(j) * massFlowComponent(j,'2') * 2.20462 ) * spillDuration
;

TOTAL_BTU_IN_PROCESS_COLUMN1_SPILL..
totalBTUinProcess =G=   sum(j, deltaCombustionComponent(j) * massFlowComponent(j,'7') * 2.20462 ) * spillDuration
;

TOTAL_BTU_IN_PROCESS_COLUMN2_SPILL..
totalBTUinProcess =G=   sum(j, deltaCombustionComponent(j) * massFlowComponent(j,'9') * 2.20462 ) * spillDuration
;


*TOTAL_BTU_IN_PROCESS_COLUMN3_SPILL..
*totalBTUinProcess =G=   sum(j, deltaCombustionComponent(j) * massFlowComponent(j,'9') * 2.20462 ) * spillDuration
*;


* ====================================================================================================================

* CONCENTRATION OF COMPONENT J IN EQUIPMENT

EQUATIONS
CONCENTRATION_COMPONENT_EQUIPMENT
MASS_FLOW_COMPONENT_REACTOR
MASS_FLOW_COMPONENT_COOLER
MASS_FRACTION_ORGANIC_EBENZ_STREAM3
MASS_FRACTION_ORGANIC_STY_STREAM3
MASS_FRACTION_ORGANIC_TOL_STREAM3
MASS_FRACTION_ORGANIC_BENZ_STREAM3
DENSITY_STREAM_3
MASS_FLOW_COMPONENT_COLUMN1
MASS_FLOW_COMPONENT_COLUMN2
*MASS_FLOW_COMPONENT_COLUMN3
VOLUMETRIC_FLOW_REACTOR
TOTAL_MOLAR_FLOW
VOLUMETRIC_FLOW_COOLER
VOLUMETRIC_FLOW_COLUMN1
VOLUMETRIC_FLOW_COLUMN2
*DENSITY_STREAM_9
*MASS_FRACTION_ORGANIC_EBENZ_STREAM9
*MASS_FRACTION_ORGANIC_STY_STREAM9
*MASS_FRACTION_ORGANIC_TOL_STREAM9
*MASS_FRACTION_ORGANIC_BENZ_STREAM9
*VOLUMETRIC_FLOW_COLUMN3
;

CONCENTRATION_COMPONENT_EQUIPMENT(j,e)..
concentrationComponent(j,e) * volumetricFlow(e)=E= averageMassFlowComponent(j,e)
;

MASS_FLOW_COMPONENT_REACTOR(j)..
averageMassFlowComponent(j,'Reactor') =E= massFlowComponent(j,'1') * 2.20462
;

MASS_FLOW_COMPONENT_COOLER(j)..
averageMassFlowComponent(j,'Cooler') =E= massFlowComponent(j,'2') * 2.20462
;

MASS_FLOW_COMPONENT_COLUMN1(j)..
averageMassFlowComponent(j,'Column1') =E= massFlowComponent(j,'7') * 2.20462
;

MASS_FLOW_COMPONENT_COLUMN2(j)..
averageMassFlowComponent(j,'Column2') =E= massFlowComponent(j,'9') * 2.20462
;

*MASS_FLOW_COMPONENT_COLUMN3(j)..
*averageMassFlowComponent(j,'Column3') =E= massFlowComponent(j,'9') * 2.20462
*;



* ============================================================================
* VOLUMETRIC FLOW
* ============================================================================

VOLUMETRIC_FLOW_REACTOR..
*volumetricFlow('Reactor') =E= -1011 + 780 * molarFlowComponent('EB','1') + 44.72 * Length('Reactor')
volumetricFlow('Reactor') * pressure('1') * 1e5 =E=  totalMolarFlow('1')* Rgas * (temperature('1') + 273 ) * 1e3
;


TOTAL_MOLAR_FLOW(m)..
totalMolarFlow(m) =E= sum(j, molarFlowComponent(j,m) )
;

VOLUMETRIC_FLOW_COOLER..
*volumetricFlow('Cooler') =E= -3517 + 767.4 * molarFlowComponent('EB','1') + 214.9 * Length('Reactor')
volumetricFlow('Cooler') * pressure('2')*1e5 =E= totalMolarFlow('2') * Rgas * ( 273 + temperature('2') )  * 1e3
;


MASS_FRACTION_ORGANIC_EBENZ_STREAM3..
massFractionOrganic3('Ebenz') * ( massFlowComponent('EB','3') + massFlowComponent('Sty','3')  + massFlowComponent('Tol','3') + massFlowComponent('Benz','3') ) =E= massFlowComponent('EB','3')
;

MASS_FRACTION_ORGANIC_STY_STREAM3..
massFractionOrganic3('Sty') * ( massFlowComponent('EB','3') + massFlowComponent('Sty','3')  + massFlowComponent('Tol','3') + massFlowComponent('Benz','3') ) =E= massFlowComponent('STY','3')
;

MASS_FRACTION_ORGANIC_TOL_STREAM3..
massFractionOrganic3('Tol') * ( massFlowComponent('EB','3') + massFlowComponent('Sty','3')  + massFlowComponent('Tol','3') + massFlowComponent('Benz','3') ) =E= massFlowComponent('Tol','3')
;

MASS_FRACTION_ORGANIC_BENZ_STREAM3..
massFractionOrganic3('Benz') * ( massFlowComponent('EB','3') + massFlowComponent('Sty','3')  + massFlowComponent('Tol','3') + massFlowComponent('Benz','3') ) =E= massFlowComponent('Benz','3')
;

DENSITY_STREAM_3..
density3   =E=  sum (i,   DensityOrganicComponent(i) * massFractionOrganic3(i) )
;



PARAMETER
d1 "kg/m3" / 880.672886/
M1 / 103.22577/
d2 / 802.878038  /
M2 /104.110256 / ;


VOLUMETRIC_FLOW_COLUMN1..
volumetricFlow('Column1') =E= sum(j,molarFlowComponent(j,'7') ) * M1  /   d1
* volumetricFlow('Column1') =E= -0.01305 + 0.1194 * molarFlowComponent('EB','1') -0.0006989 * Length('Reactor')
* volumetricFlow('Column1') * density3 =E= sum(j, massFlowComponent(j,'7') )

;


VOLUMETRIC_FLOW_COLUMN2..
volumetricFlow('Column2') =E=  sum(j, molarFlowComponent(j,'9') ) * M2/ d2
*volumetricFlow('Column2') =E= 0.001738 + 0.1356 *  molarFlowComponent('EB','1')  + 3.415e-07 * Length('Reactor')
*volumetricFlowEquipment('Column2') * density9 =E= sum(j, massFlowComponent(j,'9') )
;

*DENSITY_STREAM_9..
*density9   =E=  sum (i,   DensityOrganicComponent(i) * massFractionOrganic9(i) )
*;

*MASS_FRACTION_ORGANIC_EBENZ_STREAM9..
*massFractionOrganic9('Ebenz') * ( massFlowComponent('EB','9') + massFlowComponent('Sty','9')  + massFlowComponent('Tol','9') + massFlowComponent('Benz','9') ) =E= massFlowComponent('EB','9')
*;

*MASS_FRACTION_ORGANIC_STY_STREAM9..
*massFractionOrganic9('Sty') * ( massFlowComponent('EB','9') + massFlowComponent('Sty','9')  + massFlowComponent('Tol','9') + massFlowComponent('Benz','9') ) =E= massFlowComponent('Sty','9')
*;

*MASS_FRACTION_ORGANIC_TOL_STREAM9..
*massFractionOrganic9('Tol') * ( massFlowComponent('EB','9') + massFlowComponent('Sty','9')  + massFlowComponent('Tol','9') + massFlowComponent('Benz','9') ) =E= massFlowComponent('Tol','9')
*;

*MASS_FRACTION_ORGANIC_BENZ_STREAM9..
*massFractionOrganic9('Benz') * ( massFlowComponent('EB','9') + massFlowComponent('Sty','9')  + massFlowComponent('Tol','9') + massFlowComponent('Benz','9') ) =E= massFlowComponent('Benz','9')
*;



* =======================================================================================================================0


POSITIVE VARIABLE
AT1    Cooler inlet difference temperature  [ºC]
AT2    Cooler outlet difference temperature [ºC]

SCALAR
coolerDiameter cooler diameter [m];


coolerDiameter= 0.05 * 20    ;


EQUATIONS
* EQUIPMENT SIZE
REACTOR_VOLUME
REACTOR_AREA
COOLER_VOLUME
COOLER_AREA
COOLER_Q
MASS_FLOW_COMPONENT
COOLER_DELTA_TML
COOLER_DELTA_TML_IN
COOLER_DELTA_TML_OUT
COOLER_LENGTH
COLUMN1_VOLUME
COLUMN1_AREA
*COLUMN1_DIAMETER
COLUMN2_VOLUME
COLUMN2_AREA
*COLUMN2_DIAMETER
*COLUMN3_VOLUME
*COLUMN3_AREA
*COLUMN3_DIAMETER
COLUMN1_LENGTH
COLUMN2_LENGTH
*COLUMN3_LENGTH
;

REACTOR_VOLUME..
Volume('Reactor') =E= Area('Reactor') * Length('Reactor')
;

REACTOR_AREA..
Area('Reactor') =E= pi * POWER(reactorDiameter,2)/4
;

COOLER_VOLUME..
Volume('Cooler') =E= pi * POWER( coolerDiameter, 2 ) * Length('Cooler')
;

COOLER_AREA..
Area('Cooler') * (coolerU * coolerdeltaTml)  =E= coolerQ
;

COOLER_Q..
coolerQ =E=  sum(j, massFlowComponent(j,'2') * heatCapacity(j) ) * ( temperature('2') - temperature('3') )
;

MASS_FLOW_COMPONENT(j,m)..
massFlowComponent(j,m) =E= molarFlowComponent(j,m) *  molecularWeight(j)
;

COOLER_DELTA_TML_IN..
 AT1 =E= temperature('2') - 25
;

COOLER_DELTA_TML_OUT..
 AT2 =E= temperature('3') - 20
;

COOLER_DELTA_TML..
coolerdeltaTml =E= ( 0.5 * AT1 * AT2 * ( AT1 + AT2 ) ) ** (1/3);
;

COOLER_LENGTH..
Length('Cooler') * pi * coolerDiameter  =E= Area('Cooler')
;

COLUMN1_VOLUME..
Volume('Column1') =E= Area('Column1') * Length('Column1')
;

COLUMN1_AREA..
Area('Column1') =E= AreaColumn('Tol_EBenz','s1')
;

COLUMN1_LENGTH..
Length('Column1') =E= H('Tol_EBenz','s1') +  H('Tol_EBenz','s2')
;

COLUMN2_VOLUME..
Volume('Column2') =E= Area('Column2') * Length('Column2')
;

COLUMN2_AREA..
Area('Column2') =E= AreaColumn('EBenz_Sty','s1')
;

COLUMN2_LENGTH..
Length('Column2') =E= H('EBenz_Sty','s1') +  H('EBenz_Sty','s2')
;


*=====================================================================================================

* ECONOMICS


SCALARS
CatalystPrice  Catalyst price [$·yr^-1]        /10/
catalystDensity catalyst density [kg·m^-3]     /2350/


;
PARAMETERS

UpdateFactor(p)  update factor applied to bare module cost
/Vessel  1.4511, Cooler  1.4511, Tower1 1.4511, Tower2 1.4511, Tray1  34.8264,
Tray2  43.5330, Condenser1  1.4511, Condenser2  1.4511, Reboiler1  1.4511,
Reboiler2  1.4511/

B1(p)  bare module factor FBM = B1 + B2 * Fm * Fp
/Vessel  1.49, Cooler  1.63, Tower1      2.25, Tower2      2.25, Tray1   1,
Tray2        1, Condenser1  1.63, Condenser2  1.63, Reboiler1  1.63, Reboiler2  1.63/

B2(p)  bare module factor FBM = B1 + B2 * Fm * Fp
/Vessel  1.52, Cooler  1.66, Tower1      1.82, Tower2      1.82, Tray1  1, Tray2        1,
Condenser1  1.66, Condenser2  1.66, Reboiler1  1.66, Reboiler2  1.66/

Fm(p)  bare module factor FBM = B1 + B2 * Fm * Fp
/Vessel  1, Cooler  1, Tower1      1, Tower2      1, Tray1  1, Tray2        1,
Condenser1  1, Condenser2  1, Reboiler1  1, Reboiler2  1/

Fp(p)  bare module factor FBM = B1 + B2 * Fm * Fp
/Vessel  1, Cooler  1.3, Tower1      1, Tower2      1, Tray1  1, Tray2        1,
Condenser1  1.3, Condenser2  1.3, Reboiler1  1.3, Reboiler2  1.3 /

 ;

POSITIVE VARIABLES
TAC                             total annualised cost [MM$·year^-1]
CAPEX                           total capital expediture [$·year^-1]
OPEX                            total annualised operation expense [$·year^-1]
EquipmentCBMUpdate(p)           bare module cost Update of each part of equipment [$]
EquipmentCBM(p)                 bare module cost of each part of equipment [$]
EquipmentCp0(p)                 purchased cost for base conditions
EquipmentFBMI(p)                bare module factor

coolingWaterCondenser1         cooling water cost condenser 1 [$·yr^-1]
coolingWaterCondenser2         cooling water cost condenser 2 [$·yr^-1]
steamReboiler1                         steam cost reboiler  1 [$·yr^-1]
steamReboiler2                         steam cost reboiler  2 [$·yr^-1]
coolingWaterCooler             cooling water cost cooler      [$·yr^-1]
catalystCost                   Catalyst cost [$]

Qcondenser1                    duty exchange in condenser 1 [kJ·h^-1]
Qcondenser2                    duty exchange in condenser 2 [kJ·h^-2]
Qcondenser3                    duty exchange in condenser 3 [kJ·h^-1]
Qreboiler1                     duty exchange in reboiler  1 [kJ·h^-1]
Qreboiler2                     duty exchange in reboiler  2 [kJ·h^-1]
Qreboiler3                     duty exchange in reboiler  3 [kJ·h^-1]
 ;

VARIABLE
z        Objective function to optimize;

EQUATIONS
TOTAL_ANNUALISED_COST
TOTAL_CAPITAL_EXPEDITURE
TOTAL_ANNUALISED_OPERATION_EXPENSE
EQUIPMENT_CBM_UPDATE
EQUIPMENT_CBM
EQUIPMENT_BARE_MODULE_FACTOR
PURCHASED_COST_FOR_BASE_CONDITIONS_VESSEL
PURCHASED_COST_FOR_BASE_CONDITIONS_COOLER
PURCHASED_COST_FOR_BASE_CONDITIONS_TOWER1
PURCHASED_COST_FOR_BASE_CONDITIONS_TOWER2
*PURCHASED_COST_FOR_BASE_CONDITIONS_TOWER3
PURCHASED_COST_FOR_BASE_CONDITIONS_TRAY1
PURCHASED_COST_FOR_BASE_CONDITIONS_TRAY2
*PURCHASED_COST_FOR_BASE_CONDITIONS_TRAY3
PURCHASED_COST_FOR_BASE_CONDITIONS_CONDENSER1
PURCHASED_COST_FOR_BASE_CONDITIONS_CONDENSER2
*PURCHASED_COST_FOR_BASE_CONDITIONS_CONDENSER3
PURCHASED_COST_FOR_BASE_CONDITIONS_REBOILER1
PURCHASED_COST_FOR_BASE_CONDITIONS_REBOILER2
*PURCHASED_COST_FOR_BASE_CONDITIONS_REBOILER3
DUTY_CONDENSER_1
DUTY_CONDENSER_2
*DUTY_CONDENSER_3
DUTY_REBOILER_1
DUTY_REBOILER_2
*DUTY_REBOILER_3
*AREA_CONDENSER_1
*AREA_CONDENSER_2
*AREA_CONDENSER_3
*AREA_REBOILER_1
*AREA_REBOILER_2
*AREA_REBOILER_3
COOLING_WATER_CONDENSER1
COOLING_WATER_CONDENSER2
*COOLING_WATER_CONDENSER3
STEAM_REBOILER1
STEAM_REBOILER2
*STEAM_REBOILER3
COOLING_WATER_COOLER
*INPUT_REAGENTS_INTO_REACTOR
CATALYST_COST_CAPEX
OBJECTIVE_FUNCTION_TO_OPTIMIZE
;


TOTAL_ANNUALISED_COST..
TAC =E= (OPEX + CAPEX ) * 1e-6
;

TOTAL_CAPITAL_EXPEDITURE..
CAPEX =E= ( sum(p, EquipmentCBMUpdate(p) ) + catalystCost ) *  annualizationFactor
;

TOTAL_ANNUALISED_OPERATION_EXPENSE..
OPEX =E=  coolingWaterCondenser1 + coolingWaterCondenser2  + steamReboiler1 +
          steamReboiler2  + coolingWaterCooler
;

EQUIPMENT_CBM_UPDATE(p)..
EquipmentCBMUpdate(p) =E= EquipmentCBM(p) * UpdateFactor(p)
;


EQUIPMENT_CBM(p)..
EquipmentCBM(p) =E= EquipmentCp0(p) * EquipmentFBMI(p)
;

EQUIPMENT_BARE_MODULE_FACTOR(p)..
EquipmentFBMI(p) =E=  B1(p) + B2(p) * Fm(p) * Fp(p)
;

PURCHASED_COST_FOR_BASE_CONDITIONS_VESSEL..
EquipmentCp0('Vessel') =E=   1529 * length('Reactor') + 5477
;

PURCHASED_COST_FOR_BASE_CONDITIONS_COOLER..
EquipmentCp0('Cooler') =E=  94.04 * Area('Cooler') + 1.433e4
;

PURCHASED_COST_FOR_BASE_CONDITIONS_TOWER1..
EquipmentCp0('Tower1') =E= 595.7 * Volume('Column1') + 6762
;

PURCHASED_COST_FOR_BASE_CONDITIONS_TOWER2..
EquipmentCp0('Tower2') =E= 595.7 * Volume('Column2') + 6762
;

PURCHASED_COST_FOR_BASE_CONDITIONS_TRAY1..
EquipmentCp0('Tray1') =E= 678.9 * Area('Column1') + 11.66
;

PURCHASED_COST_FOR_BASE_CONDITIONS_TRAY2..
EquipmentCp0('Tray2') =E= 678.9 * Area('Column2') + 11.66
;

PURCHASED_COST_FOR_BASE_CONDITIONS_CONDENSER1..
EquipmentCp0('Condenser1') =E= 50.56 * AreaCond('Tol_EBenz') + 2.401e4
;

PURCHASED_COST_FOR_BASE_CONDITIONS_CONDENSER2..
EquipmentCp0('Condenser2') =E= 50.56 * AreaCond('EBenz_Sty') + 2.401e4
;

PURCHASED_COST_FOR_BASE_CONDITIONS_REBOILER1..
EquipmentCp0('Reboiler1') =E=  50.56 * AreaReb('Tol_EBenz') + 2.401e4
;

PURCHASED_COST_FOR_BASE_CONDITIONS_REBOILER2..
EquipmentCp0('Reboiler2') =E=  50.56 * AreaReb('EBenz_Sty') + 2.401e4
;

DUTY_CONDENSER_1..
Qcondenser1 =E= Qcond('Tol_EBenz') * 3600
;

DUTY_CONDENSER_2..
Qcondenser2 =E=  Qcond('EBenz_Sty') * 3600
;

DUTY_REBOILER_1..
Qreboiler1  =E= Qreb('Tol_EBenz') * 3600
;

DUTY_REBOILER_2..
Qreboiler2 =E= Qreb('EBenz_Sty') * 3600
*/ 1000
;

COOLING_WATER_CONDENSER1..
coolingWaterCondenser1 =E= WATER * Qcondenser1 * YEAR / 3600
;

COOLING_WATER_CONDENSER2..
coolingWaterCondenser2 =E= WATER * Qcondenser2 * YEAR / 3600
;

STEAM_REBOILER1..
steamReboiler1 =E= STEAM * Qreboiler1 * YEAR / 3600
;

STEAM_REBOILER2..
steamReboiler2 =E= STEAM * Qreboiler2 * YEAR / 3600
;


COOLING_WATER_COOLER..
coolingWaterCooler =E= WATER * coolerQ * YEAR / 3600
;

CATALYST_COST_CAPEX..
catalystCost =E= catalystPrice * Volume('Reactor') * catalystDensity * ( 1 - 0.445 )
;

OBJECTIVE_FUNCTION_TO_OPTIMIZE..

z =E=  FireExplosionIndex
*z =E=  TAC
*z =E= V1('Tol_EBenz')
;

EQUATIONS
PRODUCTION_STYRENE;

PRODUCTION_STYRENE..
massFlowComponent('Sty','11') =G= 850
;



model petlyuk2 /
all/;


Area.lo('Cooler') = 10;
Area.up('Cooler') = 10000;

*totalBTUinProcess.lo= 1e9 ;
*totalBTUinProcess.up= 6e9 ;

pressureOperationEquipment.lo = 0 ;
pressureOperationEquipment.up = 3 ;

AreaCond.lo('Tol_EBenz') = 10;
AreaCond.up('Tol_EBenz') = 10000;
AreaReb.lo('EBenz_Sty') = 10;
AreaReb.up('EBenz_Sty') = 10000;

*Area.lo('Column1') = 0.3848;
*Area.up('Column1') = 4.9087;


*FireExplosionIndex.lo = 213.0813    ;
*FireExplosionIndex.lo = 201.208 ;

FireExplosionIndex.up = 300 ;
totalBTUinProcess.up = 9 * 1e9 ;

*TAC.lo = 76.774 ;
*a.fx = 1.2;

Rmin.lo(c) = 1.2;
Rmin.up(c) = 80 ;

solve
petlyuk2 using NLP minimizing  z ;
*petlyuk2 using NLP minimizing  objfunValue ;
*petlyuk2 using NLP minimizing Z;



scalars
prueba1, prueba2
;
prueba1 = Mv/(rol*rov)**0.5* 1/0.7 * 1/439 * 1/0.8 * (V1.l('Tol_EBenz') +  L1.l('Tol_EBenz')*(a.l-1) );
prueba2 = Mv/(rol*rov)**0.5* 1/0.7 * 1/439 * 1/0.8 * (V1.l('EBenz_Sty') +  L1.l('EBenz_Sty')*(a.l-1) );
display prueba1, prueba2;


PARAMETER
         Diametro(c,s);

         Diametro(c,s) = (4*AreaColumn.l(c,s)/pi)**0.5;

display Diametro;

