
* The price of extenstions of heat are added to the objective
+SUM((IA,AIND,STEPP)$AINDN(IA,AIND), PHFV(AIND,STEPP)*VIHFV(IA,AIND,STEPP)*SUM(C$ICA(C,IA), ANNUITYC(C)) )

* Penalty are added if constraints are violated
+SUM((IA,IGH,S,T,IPLUSMINUS)$(AIND(IA) and IAGK_Y(IA,IGH)),VQGH_IND(IA,IGH,S,T,IPLUSMINUS))*PENALTYQ/2
+SUM((IA,IGH,S,T,IPLUSMINUS)$(AIND(IA) and IAGKN(IA,IGH)),VQGHN_IND(IA,IGH,S,T,IPLUSMINUS))*PENALTYQ/2
