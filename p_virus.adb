package body p_virus is

procedure CreeVectVirus (f : in out file_type; nb : in integer; V :out TV_Virus) is
-- {f (ouvert) contient des configurations initiales,
-- toutes les configurations se terminent par la position du virus rouge}
-- => {V a ete initialise par lecture dans f de la partie de numero nb}
piece:TR_Piece;
begin
  reset(f, in_file);
  while not end_of_file(f) loop
    read(f, piece);
    v(piece.T_Lig,piece.T_Col):=T_Piece;
  end loop;
end CreeVectVirus;

  procedure AfficheVectVirus (V : in TV_Virus) is
  -- {} => {Les valeurs du vecteur V sont affichees sur une ligne}

begin
    for i in v'range(1) loop
      for j in v'range(2) loop
        ecrire(v(i,j));
        ecrire(" ");
      end loop;
    end loop;
  end AfficheVectVirus;

procedure AfficheGrille (V : in TV_Virus) is
-- {} => {Les valeurs du vecteur V sont affichees sur une ligne}

begin --AfficheGrille
  ecrire("");
end AfficheGrille;



end p_virus;
