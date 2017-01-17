package body p_vuegraph is


procedure LancerPartie is
--{} => {à affiché la fenetre Fpartie pour selectionner la partie}

begin --LancerPartie

  Fpartie:=DebutFenetre("Nom du Joueur",400,70);
  AjouterChamp(Fpartie,"ChampNom","Votre Nom","quidam",100,10,280,30);
  AjouterBouton(Fpartie,"BoutonValider","valider",100,50,70,30);
  AjouterBouton(Fpartie,"BoutonAnnuler","annuler",180,50,70,30);
  FinFenetre(Fpartie);

  MontrerFenetre(Fpartie);

end LancerPartie;

end p_vuegraph;
