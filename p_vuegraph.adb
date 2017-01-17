package body p_vuegraph is


procedure LancerPartie(partie:out integer; continuer : out boolean) is
--{} => {a affiché la fenetre Fpartie pour selectionner la partie}
  nombouton:string(1..2);
  I, J:integer;
begin --LancerPartie
  partie:=21; --initialisation de partie pour savoir si l'utilisateur en a choisi une

  Fpartie:=DebutFenetre("Selection de la partie",700,700);
  AjouterBouton(Fpartie,"BoutonCommencer","Commencer !",225,650,70,50);
  AjouterBouton(Fpartie,"BoutonQuitter","Quitter",400,650,70,50); --(margeG, margeH, boutonL, boutonH)
  AjouterTexte(Fpartie, "Info", "", 260, 20, 160, 20);

  -- pour les boutons des niveaux
  for I in 1..4 loop
    for J in 1..5 loop
      nombouton := Integer'Image(I)(2..2) & Integer'Image(J)(2..2);
      -- le bouton en i,j s'appelle "ij" et affiche la valeur (i-1)*5+J
      AjouterBouton(Fpartie,nombouton,integer'image((i-1)*5+J),(J-1)*100+100,(I-1)*140+60,100,100);
      if (i-1)*5+J <=5 then
        ChangerCouleurFond(Fpartie,nombouton,FL_Green);
      elsif (i-1)*5+J <=10 then
        ChangerCouleurFond(Fpartie,nombouton,FL_yellow);
      elsif (i-1)*5+J <=15 then
        ChangerCouleurFond(Fpartie,nombouton,FL_darkorange);
      elsif (i-1)*5+J <=18 then
        ChangerCouleurFond(Fpartie,nombouton,FL_red);
      else
        ChangerCouleurFond(Fpartie,nombouton,FL_DarkViolet);
      end if;
      ChangerTailleTexte(Fpartie,nombouton,FL_HUGE_Size);
      ChangerStyleTexte(Fpartie,nombouton,FL_Bold_Style);
    end loop;
  end loop;

  FinFenetre(Fpartie);

  MontrerFenetre(Fpartie);

  loop
    testBouton:
    declare
      Bouton : String := (Attendrebouton(Fpartie)); -- on recupere le nom du bouton
    begin
      --Les coordonnées I et J a partir de leurs positions dans les char, moins leurs positions par rapport à '0'
      if Bouton/="BoutonQuitter" and Bouton/="BoutonCommencer" then
        I:=Character'Pos(Bouton(Bouton'First)) - Character'Pos('0');
        J:=Character'Pos(Bouton(Bouton'Last)) - Character'Pos('0');
        partie:=(i-1)*5+J; --on donne la valeur du bouton :)
        ChangerTexte(Fpartie, "Info", "Partie selectionnee : " & integer'image(partie));
      end if;
      if Bouton="BoutonQuitter" then
        CacherFenetre(Fpartie);
        continuer:=false;
      elsif Bouton="BoutonCommencer" and partie/=21 then
        CacherFenetre(Fpartie);
        continuer:=true;
      elsif Bouton="BoutonCommencer" and partie=21 then
        ChangerTexte(Fpartie, "Info", "Selectionner une partie !");
      end if;
      exit when Bouton="BoutonQuitter" or (Bouton="BoutonCommencer" and partie/=21);
    end testBouton;
  end loop;


end LancerPartie;

procedure MajAffichage(v : in TV_Virus; Fen : in out TR_Fenetre) is
--{} => {}
j:character;
nombouton:string(1..2);
begin --MajAffichage

  for i in v'range(1) loop
    if 0 = i mod 2 then
      j := T_col'succ(v'first(2));
    else
      j := v'first(2);
    end if;
    while j <= v'last(2) loop
      nombouton := Integer'Image(I)(2..2) & J;
      ChangerCouleurFond(Fen,nombouton,FL_red);
      --v(i,j)));
      if j/= T_col'succ(v'last(2)) then
        j := T_col'succ(j);
        if j/= T_col'succ(v'last(2)) then
          j := T_col'succ(j);
        end if;
      end if;
    end loop;
  end loop;

end MajAffichage;

procedure InitGrid(Fen : in out TR_Fenetre; name : in string; X, Y, cote, ecart:in natural) is
--{} => {a generer la grille de bouton sur la fenetre Fen, avec les attributs des boutons}
nombouton:string(1..2);
j:character;
jpos:integer;
begin --InitGrid
  for I in TV_Virus'range(1) loop
    if 0 = i mod 2 then
      j := T_col'succ(TV_Virus'first(2));
    else
      j := TV_Virus'first(2);
    end if;
    while j <= TV_Virus'last(2) loop
      nombouton := Integer'Image(I)(2..2) & J;
      jpos:=T_col'pos(j)-64; -- Important permet d'avoir la position de j par rapport à T_col
      -- le bouton en i,j s'appelle "ij" et affiche la valeur (i-1)*5+J
      AjouterBouton(Fen,nombouton,name,(jpos-1)*(cote+ecart)+X,(I-1)*(cote+ecart)+Y,cote,cote); --la multiplication permet d'appliquer des ecarts entre les boutons et l'ajout, l'ecarts aux bords.

      if j/= T_col'succ(TV_Virus'last(2)) then
        j := T_col'succ(j);
        if j/= T_col'succ(TV_Virus'last(2)) then
          j := T_col'succ(j);
        end if;
      end if;
    end loop;
  end loop;
end InitGrid;


procedure LancerRegleJeu(f:in out file_type) is
--{f ouvert} => {a afficher les regles du jeu dans une fenetre}
  V:TV_Virus;
begin
  reset(f, in_file);

  FRegleJeu:=DebutFenetre("Regle du jeu",700,700);
  AjouterBouton(FRegleJeu,"BoutonContinuer","Continuer",225,650,70,50);
  AjouterBouton(FRegleJeu,"BoutonQuitter","Quitter",400,650,70,50); --(margeG, margeH, boutonL, boutonH)
  AjouterTexte(FRegleJeu, "Info", "", 260, 20, 160, 20);
  --AjouterBouton(FRegleJeu,nombouton,"",(jpos-1)*35+50,(I-1)*35+40,30,30); --la multiplication permet d'appliquer des ecarts entre les boutons et l'ajout, l'ecarts aux bords.
  InitGrid(FRegleJeu, "", 50, 40, 30, 5);
  FinFenetre(FRegleJeu);
  InitVect(v);
  CreeVectVirus(f,1, v);
  MajAffichage(v, FRegleJeu);

  MontrerFenetre(FRegleJeu);
  if Attendrebouton(FRegleJeu)/="BoutonQuitter" then
    ecrire("test");
  end if;
end LancerRegleJeu;

end p_vuegraph;
