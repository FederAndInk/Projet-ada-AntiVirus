with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with p_esiut; use p_esiut;
with ada.calendar; use ada.calendar;
with p_virus; use p_virus;
with sequential_IO; use p_virus.p_Piece_IO;

with Ada.Task_Identification;  use Ada.Task_Identification;

package p_vuegraph is
----------------------Declarations

--deux fenetres pour choisir la partie, puis jouer la partie.
Fpartie, FJeu, FRegleJeu , Ffin: TR_Fenetre;
NewLine : constant Character := Character'Val (10);


---------------------Corps

procedure LancerPartie(f : in out file_type; partie:out integer; continuer : out boolean);
--{} => {a affiché la fenetre Fpartie pour selectionner la partie}

procedure LancerFin(nbcoup : in integer; nom : in string);
--{} => {affiche une fenetre avec niveau precedent/suivant, Rejouer et les infos sur la partie terminée}

--procedure LancerScores(f: in out file_type);
----{} => {}

procedure InitGrid(Fen : in out TR_Fenetre; name : in string; X, Y, cote, ecart:in natural);
--{} => {a generer la grille de bouton sur la fenetre Fen, avec les attributs des boutons}

procedure MajAffichage(v : in TV_Virus; Fen : in out TR_Fenetre);
--{aucune case de v n'est vide} => {a mis a jour les couleurs des boutons de la fenetre Jeu en fonction de ce qu'il y a dans V}

procedure Regle1Block(v : in out TV_Virus; quitter: out Boolean);
--{} => {Pour le tuto, deplace la piece violette}

procedure Regle2Block(v:in out TV_Virus; quitter: out Boolean);
--{} => {Pour le tuto, deplace la piece rouge}

procedure LancerRegleJeu(f:in out file_type);
--{} => {a afficher les regles du jeu dans une fenetre}

--procedure Bouton(...);
----{} => {}

--procedure clicPiece(...);
----{} => {}

--procedure LancerJeu(...); --todo et ne pas oublier de detecter la fin
--{} => {a affiché la fenetre de jeu}


--procedure score(...);
----{} => {a afficher les scores avec le nombre de coups et le temps passé}





end p_vuegraph;
