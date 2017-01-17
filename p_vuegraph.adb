package body p_vuegraph is


procedure LancerPartie(partie:out integer; continuer : out boolean) is
--{} => {à affiché la fenetre Fpartie pour selectionner la partie}
  nombouton:string(1..2);
  I, J:integer;
begin --LancerPartie

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
      elsif Bouton="BoutonCommencer" then
        CacherFenetre(Fpartie);
        continuer:=true;
      end if;
      exit when Bouton="BoutonQuitter" or Bouton="BoutonCommencer";
    end;
  end loop;


end LancerPartie;


procedure LancerRegleJeu () is
--{} => {a afficher les regles du jeu dans une fenetre}
begin
  FRegleJeu:=DebutFenetre("Regle du jeu",700,700);
  AjouterBouton(FRegleJeu,"BoutonCommencer","Commencer !",225,650,70,50);
  AjouterBouton(FRegleJeu,"BoutonQuitter","Quitter",400,650,70,50); --(margeG, margeH, boutonL, boutonH)
  AjouterTexte(FRegleJeu, "Info", "", 260, 20, 160, 20);
end LancerRegleJeu;

end p_vuegraph;
