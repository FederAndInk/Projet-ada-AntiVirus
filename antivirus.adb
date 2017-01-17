with P_ESiut, p_virus, text_io; use P_ESiut, p_virus, p_virus.p_Piece_IO;

procedure antivirus is
  v_grille : tv_virus;
  fConfInit: file_type;
begin --antivirus
  InitVect(v_grille);
  open(fconfinit , in_file, "Parties");
  CreeVectVirus(fConfInit, 1, v_grille);
  --AfficheVectVirus(v_grille);
  AfficheGrille(v_grille);
  ecrire_ligne(Possible(v_grille, violet, hd));
end antivirus;
