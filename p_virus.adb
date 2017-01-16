package p_virus is

procedure CreeVectVirus (f : in out file_type; nb : in integer; V :out TV_Virus);
-- {f (ouvert) contient des configurations initiales,
-- toutes les configurations se terminent par la position du virus rouge}
-- => {V a ete initialise par lecture dans f de la partie de numero nb}


  procedure AfficheVectVirus (V : in TV_Virus) is
  -- {} => {Les valeurs du vecteur V sont affichees sur une ligne}

begin
    for i in v'range loop
      for j in v'range loop
        ecrire(v(j,i));
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
