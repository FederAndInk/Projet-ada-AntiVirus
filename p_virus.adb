package p_virus is


  procedure AfficheVectVirus (V : in TV_Virus) is
  -- {} => {Les valeurs du vecteur V sont affichees sur une ligne}

  begin
    for i in v'range loop
      ecrire(v(i));
      ecrire(" ");
    end loop;

  end AfficheVectVirus;



end p_virus;
