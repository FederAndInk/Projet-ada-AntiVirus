with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with p_esiut; use p_esiut;
with ada.calendar; use ada.calendar;
with p_virus; use p_virus;
with sequential_IO; use p_virus.p_Piece_IO;
with ada.directories; use ada.directories;

with Ada.Task_Identification;  use Ada.Task_Identification;

package p_vuegraph is
----------------------Declarations

type TR_score is record
  nom : string(1..15);
  score : integer;
  niveau : natural;
  date : time;
end record;
type tv_score is array (integer range <>) of TR_score;

--deux fenetres pour choisir la partie, puis jouer la partie.
Fpartie, FJeu, FRegleJeu , Ffin : TR_Fenetre;
NewLine : constant Character := Character'Val (10);

package p_score_IO is new sequential_IO (TR_score); use p_score_IO;

E_choiceError:exception;

---------------------Corps

procedure LancerPartie(f : in out p_Piece_IO.file_type; partie:out integer; Quitter : out boolean);
--{} => {a affiché la fenetre Fpartie pour selectionner la partie}

procedure LancerFin(nbcoup : in integer; nom : in string);
--{} => {affiche une fenetre avec niveau precedent/suivant, Rejouer et les infos sur la partie terminée}

function calcscore(nbcoup, temps: in natural) return natural;
----{} => {}

function nbElem(f : in p_score_IO.file_type) return natural;
----{} => {}

procedure Afficherscore(v : in Tv_score; Fen : in out TR_Fenetre; nomtxtasc : string);
---- {} => {}

procedure LancerScores(fen : in out TR_Fenetre;  trscore : in out TR_score);
----{} => {}

procedure InitGrid(Fen : in out TR_Fenetre; name : in string; X, Y, cote, ecart:in natural);
--{} => {a generer la grille de bouton sur la fenetre Fen, avec les attributs des boutons}

procedure MajAffichage(v : in TV_Virus; Fen : in out TR_Fenetre);
--{aucune case de v n'est vide} => {a mis a jour les couleurs des boutons de la fenetre Jeu en fonction de ce qu'il y a dans V}

procedure Regle1Block(v : in out TV_Virus; quitter: out Boolean);
--{} => {Pour le tuto, deplace la piece violette}

procedure Regle2Block(v:in out TV_Virus; quitter: out Boolean);
--{} => {Pour le tuto, deplace la piece rouge}

procedure LancerRegleJeu(f:in out p_Piece_IO.file_type);
--{} => {a afficher les regles du jeu dans une fenetre}


procedure BoutonF(v : in out TV_Virus;
                  f : in out p_Piece_IO.file_type;
                  Quitter : out boolean;
                  coul : in out t_piece;
                  win : in out TR_Fenetre);
--{} => {}


procedure tribulle(v : in out tv_score; choix : in integer);
--{} => {}




function infstrict(a,b : TR_score; choix : in integer) return boolean;
--{} => {}

procedure permut(a,b : in out TR_score);
--{} => {}

procedure LancerJeu(v: in out tv_virus;
                    f : in out p_Piece_IO.file_type;
                    quitter : out boolean);
--{} => {a affiché la fenetre de jeu}

end p_vuegraph;
