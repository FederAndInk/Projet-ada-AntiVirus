package p_virus is

procedure CreeVectVirus (f : in out file_type; nb : in integer; V :out TV_Virus);
-- {f (ouvert) contient des configurations initiales,
-- toutes les configurations se terminent par la position du virus rouge}
-- => {V a ete initialise par lecture dans f de la partie de numero nb}

end p_virus;
