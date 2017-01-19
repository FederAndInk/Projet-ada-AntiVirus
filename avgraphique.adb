with p_vuegraph; use p_vuegraph;
with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with p_esiut; use p_esiut;
with ada.calendar; use ada.calendar;
with p_virus; use p_virus;
with text_io; use p_virus.p_Piece_IO;
use p_virus.p_Direction_IO, p_virus.p_Pieceenum_IO, p_vuegraph.p_score_IO;
with ada.directories; use ada.directories;

procedure avgraphique is
  partieNum, nbcoup : integer;
  stop : boolean;
  fconfinit : p_Piece_IO.file_type;
  v_grille : tv_virus;
  nom : string(1..2);
  vscore : TR_score;
  Fenscore: TR_Fenetre;
begin --avgraphique


  p_Piece_IO.open(fconfinit , in_file, "Parties");
  InitialiserFenetres;
  LancerScores(Fenscore, vscore);
  nbcoup:=1;
  --fenetre nom...
  nom:="Ha";

  LancerPartie(fconfinit, partieNum, stop);
  if not stop then
    InitVect(v_grille);
    CreeVectVirus(fConfInit,partieNum, v_grille);
    --AfficheGrille(v_grille);
    LancerJeu(v_grille,fconfinit, stop);
    if not stop then
      LancerFin(nbcoup, nom);
    end if;
    --LancerRegleJeu; --test regle jeu
  end if;
end avgraphique;
