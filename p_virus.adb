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
  while not end_of_file(f) and nbconfig/=nb loop --move till the good config --TODO prendre en compte les depassement 
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


function ReplaceCoul(coul: in t_piece) return character is
--{} => {remplace une couleur par un character}
begin
  if coul /= vide then
    return integer'image(t_piece'pos(coul))(2);
  else return '.';
  end if;
end ReplaceCoul;

function ReplaceCoul(coul: in integer) return t_piece is
--{} => {remplace une couleur par un character}
begin
  return t_piece'val(coul);
end ReplaceCoul;


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
  newv : TV_virus := v;
  begin
    for i in v'range(1) loop
      for j in v'range(2) loop
        if v(i,j) /= coul then
          newv(i,j) := v(i,j);
        else
          newv(i,j) := vide;
        end if;
      end loop;
    end loop;
    for i in v'range(1) loop
      for j in v'range(2) loop
        if coul = v(i,j) then
          ecrire(i);ecrire(' ');ecrire(j);
          if Dir = bg then
            newv(i+1,T_col'pred(j)) := coul;
          elsif Dir = hg then
            newv(i-1,T_col'pred(j)) := coul;
          elsif Dir = bd then
            newv(i+1,T_col'succ(j)) := coul;
          else
            newv(i-1,T_col'succ(j)) := coul;
          end if;
        end if;
      end loop;
    end loop;
    v := newv;
  end Deplacement;

  function Possible (V : in TV_Virus; Coul : in T_Piece; Dir : in T_Direction) return Boolean is
  -- {P appartient a la grille V} => {resultat = vrai si la piece de couleur Coul peut etre
  --                                             deplacee dans la direction Dir}
  tposs:Boolean;
  begin
    if Coul = blanc then
      return false;
    end if;
    for i in v'range(1) loop
      for j in v'range(2) loop
        if v(i,j)=Coul then
          case Dir is
            when bg =>
              tposs:=v(i+1,T_col'pred(j))=vide or v(i+1,T_col'pred(j))=Coul;
            when hg =>
              tposs:=v(i-1,T_col'pred(j))=vide or v(i-1,T_col'pred(j))=Coul;
            when bd =>
              tposs:=v(i+1,T_col'succ(j))=vide or v(i+1,T_col'succ(j))=Coul;
            when hd =>
              tposs:=v(i-1,T_col'succ(j))=vide or v(i-1,T_col'succ(j))=Coul;
          end case;
          if not tposs then
            return false;
          end if;
        end if;
      end loop;
    end loop;
    return true;
    exception
    when constraint_error => ecrire_ligne("Vous êtes contre un mur!");return false;
  end Possible;

end p_virus;
