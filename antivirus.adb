with P_ESiut, p_virus, text_io; use P_ESiut, p_virus, p_virus.p_Piece_IO;
use p_virus.p_Direction_IO,p_virus.p_Pieceenum_IO;
procedure antivirus is
  v_grille : tv_virus;
  fConfInit: file_type;
  niveau, pieceselect : integer;

  Dir : T_Direction;
begin --antivirus
  InitVect(v_grille);
  open(fconfinit , in_file, "Parties");
  ecrire("Saisir un niveau de difficulté croissant de 1 à 20 :"); lire(niveau);
  CreeVectVirus(fConfInit,niveau, v_grille);
  AfficheGrille(v_grille);

  while not Gueri(v_grille) loop
    ecrire("entrer le chiffre correspondant à la pièce que vous voulez déplacer:");
    lire(pieceselect);
    ecrire("indiquez une direction (hg, hd, bg, bd)");
    lire(Dir);
    if possible(v_grille,ReplaceCoul(pieceselect),Dir) then
      Deplacement(v_grille,ReplaceCoul(pieceselect),Dir);
       ecrire_ligne("déplacement effectué");
    else
      ecrire_ligne("DÉPLACEMENT IMPOSSIBLE!!!!!!!!!!!!!!!!");
    end if;
    AfficheGrille(v_grille);
  end loop;
ecrire("Vous avez réussi le niveau");ecrire(niveau);ecrire_ligne("!!!!!!");
end antivirus;
