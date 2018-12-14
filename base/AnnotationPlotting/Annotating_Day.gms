
****************************************************************************************************
****************** Equatuions
****************************************************************************************************

* Objective function
QOBJ.stage = card(blocks) + 2;

*** Y index in front if it is BB4

* Electricity generation equals demand (MW)
QEEQ.stage(IR,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;

* Heat generation equals demand (MW)
QHEQ.stage(IA,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;

* Fuel consumption rate.
QGFEQ.stage(IA,G,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;
* CHP generation (back pressure) limited by Cb-line (MW)
QGCBGBPR.stage(IA,G,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;

* CHP generation (extraction) limited by Cb-line (MW)
QGCBGEXT.stage(IA,G,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;

* CHP generation (extraction) limited by Cv-line (MW)
QGCVGEXT.stage(IA,G,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;

* Electric heat generation (MW)
QGGETOH.stage(IA,G,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;

*Intra-seasonal heat storage dynamic equation (MWh)
QHSTOVOLTS.stage(IA,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;
QHSTOVOLTS.stage(IA,S,T)$(HHH24TTT(T,'H24')) = card(blocks) + 2;
QHSTOVOLTS.stage(IA,S,T)$(HHH24TTT(T,'H01')) = card(blocks) + 2;

*Transmission capacity constraint (MW)
QXK.stage(IRRRE,IRRRI,S,T)= sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;


******* RAMPING IS LINKING BUT ONLY FOR THE LAST HOUR OF ONE DAY TO THE FIRST HOUR OF THE NEXT DAY
******* SO FIRST WE ASSIGN TO BLOCKS AND THEN WE ASSIGN THE LINKING
*  Maximum fuel rampup for exogenous capacities (MWh)
*QGFRAMPUP.stage(IA,G,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;
* Maximum fuel rampdown for exogenous capacities (MWh)
*QGFRAMPDOWN.stage(IA,G,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;


* LINKING
*QGFRAMPUP.stage(IA,G,S,T)$(HHH24TTT(T,'H24')) = card(blocks) + 2;
*QGFRAMPDOWN.stage(IA,G,S,T)$(HHH24TTT(T,'H24')) = card(blocks) + 2;

*QGFRAMPUP.stage(IA,G,S,T)$(HHH24TTT(T,'H01')) = card(blocks) + 2;
*QGFRAMPDOWN.stage(IA,G,S,T)$(HHH24TTT(T,'H01')) = card(blocks) + 2;


* For instance 2
QHYRSSEQ.stage(IA,S) = card(blocks) + 2;

QHYRSMAXVOL.stage(IA,S) = sum(blockAssignmentSeason(blocks,S),ord(blocks)) + 1;



****************************************************************************************************
****************** Variables
****************************************************************************************************
* Objective function value (MMoney)
VOBJ.stage =  1;


* Electricity generation (MW), existing units
VGE_T.stage(IA,G,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;
* Heat generation (MW), existing units

*** NOT IN THE SAME BLOCK!
VGH_T.stage(IA,G,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;

* Fuel consumption rate (MW), existing units
VGF_T.stage(IA,G,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;
*VGF_T.stage(IA,G,S,T)$(HHH24TTT(T,'H24')) = 1;


* Electricity export from region IRRRE to IRRRI (MW)
VX_T.stage(IRRRE,IRRRI,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;

* Intra-seasonal heat storage loading (MW)
VHSTOLOADTS.stage(IA,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;

VHSTOVOLTS.stage(IA,S,T) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;
*VHSTOVOLTS.stage(IA,S,'T168') = 1;

* Feasibility in electricity balance equation QEEQ (MW)
VQEEQ.stage(IR,S,T,IPLUSMINUS) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;

* Feasibility in heat balance equation QHEQ (MW)
VQHEQ.stage(IA,S,T,IPLUSMINUS) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;

* Feasibility in intra-seasonal heat storage equation VQHSTOVOLT (MWh)
VQHSTOVOLTS.stage(IA,S,T,IPLUSMINUS) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;

* Feasibility in Transmission capacity constraint (MW)
VQXK.stage(IRRRE,IRRRI,S,T,IPLUSMINUS) = sum(blockAssignmentSeasonDay(blocks,S,T),ord(blocks)) + 1;


* Instance 2 extra
VHYRS_S.stage(IA,S) = sum(blockAssignmentSeason(blocks,S),ord(blocks)) + 1;
VQHYRSSEQ.stage(IA,S,IPLUSMINUS) = sum(blockAssignmentSeason(blocks,S),ord(blocks)) + 1;
VQHYRSMINMAXVOL.stage(IA,S,IPLUSMINUS)  = sum(blockAssignmentSeason(blocks,S),ord(blocks)) + 1;




$ontext
QGFEQ(IA,G,IS3,T)$IAGK_Y(IA,G) ..
    VGF_T(IA,G,IS3,T)
  =E=
   ( (VGE_T(IA,G,IS3,T)/(GDATA(G,'GDFE')*(1$(NOT GEFFRATE(IA,G))+GEFFRATE(IA,G))))$(IGNOTETOH(G) AND IGE(G))
    +(GDATA(G,'GDCV')*VGH_T(IA,G,IS3,T)/(GDATA(G,'GDFE')*(1$(NOT GEFFRATE(IA,G))+GEFFRATE(IA,G))))$IGH(G)
    )$(NOT IGBYPASS(G))

+  ( ((GDATA(G,'GDCB')*((VGH_T(IA,G,IS3,T)*GDATA(G,'GDBYPASSC') + VGE_T(IA,G,IS3,T))/(GDATA(G,'GDCB') + GDATA(G,'GDBYPASSC')))/(GDATA(G,'GDFE')*(1$(NOT GEFFRATE(IA,G))+GEFFRATE(IA,G)))))
   +((GDATA(G,'GDCV')*((VGH_T(IA,G,IS3,T)*GDATA(G,'GDBYPASSC') + VGE_T(IA,G,IS3,T))/(GDATA(G,'GDCB') + GDATA(G,'GDBYPASSC')))/(GDATA(G,'GDFE')*(1$(NOT GEFFRATE(IA,G))+GEFFRATE(IA,G)))))
   )$IGBYPASS(G)
$offtext
