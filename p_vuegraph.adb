package body p_vuegraph is


procedure LancerPartie(partie:out integer) is
--{} => {à affiché la fenetre Fpartie pour selectionner la partie}
  nombouton:string(1..2);
begin --LancerPartie

  Fpartie:=DebutFenetre("Selection de la partie",700,700);
  --AjouterChamp(Fpartie,"ChampNom","Votre Nom","quidam",100,10,280,30);
  AjouterBouton(Fpartie,"BoutonCommencer","Commencer !",225,650,70,50);
  AjouterBouton(Fpartie,"BoutonQuitter","Quitter",400,650,70,50); --(margeG, margeH, boutonL, boutonH)

  -- pour les boutons des niveaux
  for I in 1..4 loop
    for J in 1..5 loop
      nombouton := Integer'Image(I)(2..2) & Integer'Image(J)(2..2);
      -- le bouton en i,j s'appelle "ij" et affiche la valeur (i-1)*5+J
      AjouterBouton(FJeu,nombouton,integer'image((i-1)*5+J),(J-1)*100+100,(I-1)*140+60,100,100);
      if (i-1)*5+J <=5 then
        ChangerCouleurFond(FJeu,nombouton,FL_Green);
      elsif (i-1)*5+J <=10 then
        ChangerCouleurFond(FJeu,nombouton,FL_yellow);
      elsif (i-1)*5+J <=15 then
        ChangerCouleurFond(FJeu,nombouton,FL_darkorange);
      elsif (i-1)*5+J <=18 then
        ChangerCouleurFond(FJeu,nombouton,FL_red);
      else
        ChangerCouleurFond(FJeu,nombouton,FL_DarkViolet);
      end if;
      ChangerTailleTexte(Fjeu,nombouton,FL_HUGE_Size);
      ChangerStyleTexte(Fjeu,nombouton,FL_Bold_Style);
    end loop;
  end loop;

  FinFenetre(Fpartie);

  MontrerFenetre(Fpartie);

  if AttendreBouton(Fpartie)="BoutonAnnuler" then
    CacherFenetre(Fpartie);
  end if;


end LancerPartie;

end p_vuegraph;
