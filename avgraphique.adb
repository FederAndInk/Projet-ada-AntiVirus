with p_vuegraph; use p_vuegraph;
with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with p_esiut; use p_esiut;
with ada.calendar; use ada.calendar;
with p_virus; use p_virus;
with text_io; use p_virus.p_Piece_IO;
use p_virus.p_Direction_IO, p_virus.p_Pieceenum_IO;

procedure avgraphique is
  partieNum, nbcoup:integer;
  v_grille:tv_virus;
  fconfinit:file_type;
  keepgoing:boolean;
  nom: string(1..2);
begin --avgraphique
  open(fconfinit , in_file, "Parties");
  InitialiserFenetres;
  nbcoup:=1;
  --fenetre nom...
  nom:="Ha";

  LancerPartie(fconfinit, partieNum, keepgoing);
  if keepgoing then
    InitVect(v_grille);
    CreeVectVirus(fConfInit,partieNum, v_grille);
    AfficheGrille(v_grille);

    LancerFin(nbcoup, nom);
    --LancerRegleJeu; --test regle jeu
  end if;
end avgraphique;
