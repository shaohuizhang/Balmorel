* The following handles the combination technologies:

VGE_T.UP(IA,IGCOMB1,S,T)$(IGKE(IGCOMB1) AND GDATA(IGCOMB1,'GDCOMBGSHAREK1')) =
  (IGKVACCTOY(IA,IGCOMB1) + IGKFX_Y(IA,IGCOMB1))* (1$(NOT IGKRATE(IA,IGCOMB1,S,T)) + IGKRATE(IA,IGCOMB1,S,T))*GDATA(IGCOMB1,'GDCOMBGSHAREK1');

LOOP(IGCOMB1,
  VGE_T.UP(IA,IGCOMB2,S,T)$(IGKE(IGCOMB1) AND GGCOMB(IGCOMB1,IGCOMB2) AND GDATA(IGCOMB2,'GDCOMBGSHAREK1')) =
  (IGKVACCTOY(IA,IGCOMB1) + IGKFX_Y(IA,IGCOMB1))*(1$(NOT IGKRATE(IA,IGCOMB1,S,T)) + IGKRATE(IA,IGCOMB1,S,T))*GDATA(IGCOMB2,'GDCOMBGSHAREK1')
);

VGF_T.UP(IA,IGCOMB1,S,T)$GDATA(IGCOMB1,'GDCOMBFSHAREK1') =
    (IGKVACCTOY(IA,IGCOMB1) + IGKFX_Y(IA,IGCOMB1))* (1$(NOT IGKRATE(IA,IGCOMB1,S,T)) + IGKRATE(IA,IGCOMB1,S,T))*GDATA(IGCOMB1,'GDCOMBFSHAREK1');

LOOP(IGCOMB1,
  VGF_T.UP(IA,IGCOMB2,S,T)$(GGCOMB(IGCOMB1,IGCOMB2) AND GDATA(IGCOMB2,'GDCOMBFSHAREK1')) =
  (IGKVACCTOY(IA,IGCOMB1) + IGKFX_Y(IA,IGCOMB1))*(1$(NOT IGKRATE(IA,IGCOMB1,S,T)) + IGKRATE(IA,IGCOMB1,S,T))*GDATA(IGCOMB2,'GDCOMBFSHAREK1')
);

VGH_T.UP(IA,IGCOMB1,S,T)$(IGKH(IGCOMB1) AND GDATA(IGCOMB1,'GDCOMBGSHAREK1')) =
   (IGKVACCTOY(IA,IGCOMB1) + IGKFX_Y(IA,IGCOMB1))*(1$(NOT IGKRATE(IA,IGCOMB1,S,T)) + IGKRATE(IA,IGCOMB1,S,T))*GDATA(IGCOMB1,'GDCOMBGSHAREK1');

LOOP(IGCOMB1,
  VGH_T.UP(IA,IGCOMB2,S,T)$(IGKH(IGCOMB1) AND GGCOMB(IGCOMB1,IGCOMB2) AND GDATA(IGCOMB2,'GDCOMBGSHAREK1'))=
  (IGKVACCTOY(IA,IGCOMB1) + IGKFX_Y(IA,IGCOMB1))*(1$(NOT IGKRATE(IA,IGCOMB1,S,T)) + IGKRATE(IA,IGCOMB1,S,T))*GDATA(IGCOMB2,'GDCOMBGSHAREK1')
);


IAGK_Y(IA,IGCOMB2)$SUM(IGCOMB1$(IAGK_Y(IA,IGCOMB1) and GGCOMB(IGCOMB1,IGCOMB2)),1)=yes;
