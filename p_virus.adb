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

  function ReplaceCoul(coul : in T_Piece) return character is -- à ne ps confondre avec charcater
  --{} => {associe pour chaque valeur de Coul un "."
  --ou un chiffre correspondant}
  begin
    if coul = rouge then
      return '0';
    elsif coul = turquoise then
      return '1';
    elsif coul = orange then
      return '2';
    elsif coul = rose then
      return '3';
    elsif coul = marron then
      return '4';
    elsif coul = bleu then
      return '5';
    elsif coul = violet then
      return '6';
    elsif coul = vert then
      return '7';
    elsif coul = Jaune then
      return '8';
    elsif coul = blanc then
      return '9';
    else
      return '.';
    end if;
  end ReplaceCoul;

  procedure AfficheGrille (V : in TV_Virus) is
  -- {} => {Le contenu du vecteur V est affiche dans une grille symbolisee
  -- Les colonnes sont numerotees de A a G et les lignes sont numerotees de 1 a 7.
  -- Dans chaque case : 	. = case vide
  --			un chiffre = numero de la couleur de la piece presente dans la case
  --			le caractere 'B' = piece blanche fixe
  -- 			rien = pas une case}
  j : character;
  begin
    ecrire_ligne("\    A  B  C  D  E  F  G");
    ecrire_ligne(" \   ===================");
    for i in v'range(1) loop
      a_la_ligne;  ecrire(i); ecrire("|  ");
      if 0 = i mod 2 then
        j := T_col'succ(v'first(2));
      else
        j := v'first(2);
      end if;
      while j <= v'last(2) loop
        if (j = t_col'succ(v'first(2))) then
          ecrire("   ");
        end if;
        ecrire(ReplaceCoul(v(i,j)));
        ecrire("     ");
        if j/= T_col'succ(v'last(2)) then
          j := T_col'succ(j);
          if j/= T_col'succ(v'last(2)) then
            j := T_col'succ(j);
          end if;
        end if;
      end loop;
    end loop;
  end AfficheGrille;


  function Gueri (V : in TV_Virus) return Boolean is
  -- {} => {resultat = la piece rouge est prete a sortir (coin haut gauche)}
  begin
    return v(v'first(1),v'first(2))=rouge;
  end Gueri;

  function Presente (V : in TV_Virus; Coul : in T_Piece) return Boolean is
  -- {} => {resultat =  la piece de couleur Coul appartient a V}
  i:integer:=v'first(1);
  j:character:=v'first(2);
  begin
    while i<v'last(1) and then v(i,j)/=Coul loop
      while j<v'last(2) and then v(i,j)/=Coul loop
        j:=T_col'succ(j);
        ecrire_ligne(T_Piece'image(v(i,j)));
      end loop;
      if not (v(i,j)=Coul) then
        j:=v'first(2);
        i:=i+1;
      end if;
    end loop;
    return v(i,j)=Coul;
  end presente;


  procedure Deplacement(V : in out TV_Virus; Coul : in T_Piece; Dir :in T_Direction) is
  -- {la piece de couleur Coul peut etre deplacee dans la direction Dir}
  -- => {V a ete mis a jour suite au deplacement}
  begin
    for i in v'range(1) loop
      for j in v'range(2) loop
        if coul = v(i,j) then
          if Dir = bg then
            v(i,j) := vide;
            v(i+1,T_col'pred(j)) := coul;
          elsif Dir = hg then
            v(i,j) := vide;
            v(i-1,T_col'pred(j)) := coul;
          elsif Dir = bd then
            v(i,j) := vide;
            v(i+1,T_col'succ(j)) := coul;
          else
            v(i,j) := vide;
            v(i-1,T_col'succ(j)) := coul;
          end if;
        end if;
      end loop;
    end loop;
  end Deplacement;

  function Possible (V : in TV_Virus; Coul : in T_Piece; Dir : in T_Direction) return Boolean is
  -- {P appartient a la grille V} => {resultat = vrai si la piece de couleur Coul peut etre
  --                                             deplacee dans la direction Dir}
  tposs:Boolean;
  begin
    for i in v'range(1) loop
      for j in v'range(2) loop
        if v(i,j)=Coul then
          case Dir is
            when bg =>
              tposs:=v(i+1,T_col'pred(j))=vide;
            when hg =>
              tposs:=v(i-1,T_col'pred(j))=vide;
            when bd =>
              tposs:=v(i+1,T_col'succ(j))=vide;
            when hd =>
              tposs:=v(i-1,T_col'succ(j))=vide;
          end case;
          if not tposs then
            return false;
          end if;
        end if;
      end loop;
    end loop;
    return true;
  end Possible;

end p_virus;
