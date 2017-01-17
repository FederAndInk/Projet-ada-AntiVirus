with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with p_esiut; use p_esiut;
with ada.calendar; use ada.calendar;
with p_virus; use p_virus;


package p_vuegraph is
--deux fenetres pour choisir la partie, puis jouer la partie.
Fpartie, FJeu, FRegleJeu : TR_Fenetre;

procedure LancerPartie(partie:out integer; continuer : out boolean);
--{} => {à affiché la fenetre Fpartie pour selectionner la partie}

procedure LancerRegleJeu ();
--{} => {a afficher les regles du jeu dans une fenetre}

--procedure LancerJeu(...); --todo
--{} => {à affiché la fenetre de jeu}

end p_vuegraph;
