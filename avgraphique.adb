with p_vuegraph; use p_vuegraph;
with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with p_esiut; use p_esiut;
with ada.calendar; use ada.calendar;
with p_virus; use p_virus;
with text_io; use p_virus.p_Piece_IO;
use p_virus.p_Direction_IO, p_virus.p_Pieceenum_IO, p_vuegraph.p_score_IO, p_vuegraph.p_user_IO;
with ada.directories; use ada.directories;

procedure avgraphique is
  partieNum, i: integer;
  stop : boolean;
  fconfinit : p_Piece_IO.file_type;
  v_grille : tv_virus;
  fUser : p_user_IO.file_type;
begin --avgraphique


  p_Piece_IO.open(fconfinit , in_file, "Parties");
  InitialiserFenetres;

  LancerScores;

  --if exists("f_User.dat") then
  --  p_User_IO.open(fUser, in_file, "f_score.dat");
  --  i:=nbElem(fUser);
  --  ecrire("test I");
  --  ecrire(i);
  --  VectDyn:
  --  declare
  --    VUser: TV_User(1..nbElem(fUser));
  --  begin
  --    reset(fUser, in_file);
  --    ecrire(nbElem(fUser));
  --  fichversVect(fUser, VUser);
  --  i:=dicho(VUser, UserBack.nom);
  --  if i/=VUser'last then
  --    VUser(i):=UserBack;
  --    LancerJeu(v_grille,fconfinit, stop, user.niveau);
  --  end if;
  --end VectDyn;
  --close(fUser);
  --end if;


  LancerPartie(fconfinit, partieNum, stop);
  if not stop then
    LancerJeu(v_grille,fconfinit, stop, partieNum);
  end if;
end avgraphique;
