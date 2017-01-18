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
  partieNum, nbcoup:integer;
  v_grille:tv_virus;
  fconfinit:p_Piece_IO.file_type;
  keepgoing:boolean;
  nom: string(1..2);
  f_score : p_score_IO.file_type;
  vscore : TR_score;
begin --avgraphique

  if not exists("f_score.dat") then
    ecrire_ligne("création du fichier...");
    p_score_IO.create(f_score, out_file, "f_score.dat");
  else
    p_score_IO.open(f_score, p_score_IO.in_file, "f_score.dat");
  end if;
  p_Piece_IO.open(fconfinit , in_file, "Parties");
  InitialiserFenetres;
  LancerScores(f_score);
  nbcoup:=1;
  --fenetre nom...
  nom:="Ha";

  LancerPartie(fconfinit, partieNum, keepgoing);
  if keepgoing then
    InitVect(v_grille);
    CreeVectVirus(fConfInit,partieNum, v_grille);
    --AfficheGrille(v_grille);
    LancerJeu(v_grille,fconfinit, keepgoing);

    LancerFin(nbcoup, nom);
    --LancerRegleJeu; --test regle jeu
  end if;
end avgraphique;
