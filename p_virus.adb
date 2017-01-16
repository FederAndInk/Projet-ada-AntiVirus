package body p_virus is

procedure InitVect(v: out tv_virus) is
--{} => {v is initilised by vide piece}
begin --InitVect
  for i in v'range(1) loop
    for j in v'range(2) loop
      v(i,j) := vide ;
    end loop;
  end loop;
end InitVect;

procedure CreeVectVirus (f : in out file_type; nb : in integer; V :out TV_Virus) is
-- {f (ouvert) contient des configurations initiales,
-- toutes les configurations se terminent par la position du virus rouge}
-- => {V a ete initialise par lecture dans f de la partie de numero nb}
piece:TR_Piece;
nbrouge:integer:=0;
nbconfig:integer:=1;
begin
  reset(f, in_file);
  while not end_of_file(f) and nbconfig/=nb loop --move till the good config
    read(f, piece);
    if piece.couleur=rouge then
      nbrouge:=nbrouge+1;
      if nbrouge=2 then
        nbrouge:=0;
        nbconfig:=nbconfig+1;
      end if;
    end if;
  end loop;
  while not end_of_file(f) and nbrouge/=2 loop --fill the vector with the config till finding the last red piece
    read(f, piece);
    v(piece.ligne,piece.colonne):=Piece.couleur;
    if piece.couleur=rouge then
      nbrouge:=nbrouge+1;
    end if;
  end loop;
end CreeVectVirus;

procedure AfficheVectVirus (V : in TV_Virus) is
-- {} => {Les valeurs du vecteur V sont affichees sur une ligne}
begin
    for i in v'range(1) loop
      for j in v'range(2) loop
        ecrire(T_Piece'image(v(i,j)));
        ecrire(" ");
      end loop;
    end loop;
  end AfficheVectVirus;

  procedure AfficheGrille (V : in TV_Virus) is
  -- {} => {Le contenu du vecteur V est affiche dans une grille symbolisee
  -- Les colonnes sont numerotees de A a G et les lignes sont numerotees de 1 a 7.
  -- Dans chaque case : 	. = case vide
  --			un chiffre = numero de la couleur de la piece presente dans la case
  --			le caractere 'B' = piece blanche fixe
  -- 			rien = pas une case}
    nb : integer;
  begin
    nb := 0;
    ecrire("\  A  B  C  D  E  F  G");
    ecrire(" \ ===================");
    for i in v'range(1) loop
      nb := nb+1;
      ecrire(i); ecrire("|  ");
      AfficheVectVirus(v);
      if nb = 7 then
        nb:= 0;
        a_la_ligne;
      end if;
    end loop;
  end AfficheGrille;

end p_virus;
