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
  partieNum : integer;
  stop : boolean;
  fconfinit : p_Piece_IO.file_type;
  v_grille : tv_virus;
begin --avgraphique


  p_Piece_IO.open(fconfinit , in_file, "Parties");
  InitialiserFenetres;

  LancerScores;

  LancerPartie(fconfinit, partieNum, stop);
  if not stop then
    LancerJeu(v_grille,fconfinit, stop, partieNum);
  end if;
end avgraphique;
