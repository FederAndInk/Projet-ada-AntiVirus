with p_vuegraph; use p_vuegraph;
with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with p_esiut; use p_esiut;
with ada.calendar; use ada.calendar;
with p_virus; use p_virus;
with text_io; use p_virus.p_Piece_IO;
use p_virus.p_Direction_IO, p_virus.p_Pieceenum_IO;

procedure avgraphique is
  partieNum:integer;
  v_grille:tv_virus;
  fconfinit:file_type;
begin --avgraphique
  open(fconfinit , in_file, "Parties");
  InitialiserFenetres;
  LancerPartie(partieNum);
  --ecrire_ligne(partieNum);
  ecrire("test");
  InitVect(v_grille);
  CreeVectVirus(fConfInit,partieNum, v_grille);
  AfficheGrille(v_grille);
end avgraphique;
