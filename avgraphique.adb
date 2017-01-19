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
  stop:boolean;
  fconfinit:p_Piece_IO.file_type;
  v_grille : tv_virus;
  nom: string(1..2);
  f_score : p_score_IO.file_type;
  vscore : TR_score;
  temps:natural;
begin --avgraphique

  if not exists("f_score.dat") then
    ecrire_ligne("création du fichier...");
    p_score_IO.create(f_score, out_file, "f_score.dat");
  else
    p_score_IO.open(f_score, p_score_IO.in_file, "f_score.dat");
  end if;
  p_Piece_IO.open(fconfinit , in_file, "Parties");
  InitialiserFenetres;
  --LancerScores(f_score);
  nbcoup:=1;
  --fenetre nom...
  nom:="Ha";

  LancerPartie(fconfinit, partieNum, stop);
  if not stop then
    --AfficheGrille(v_grille);
    LancerJeu(v_grille,fconfinit, stop, nbcoup, temps, partieNum);
    if not stop then
      LancerFin(nbcoup, nom, temps);
    end if;
    --LancerRegleJeu; --test regle jeu
  end if;
end avgraphique;
