with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with p_esiut; use p_esiut;
with text_io; use text_io;

with ada.calendar; use ada.calendar;
with p_virus; use p_virus;
with sequential_IO; use p_virus.p_Piece_IO;
with ada.directories; use ada.directories;

with Ada.Task_Identification;  use Ada.Task_Identification;

package p_vuegraph is
----------------------Declarations

type TR_score is record
  nom : string(1..10);
  score : integer;
  niveau : natural;
  date : time;
end record;

type TV_Coups is array (0..100) of TV_Virus;

type TR_User is record
  nom : string(1..10);
  niveau : natural;
  --partieSauv : TV_Virus;
  --coupsSauv : TV_Coups;
  coupPos : integer;
end record;

User : TR_score;
UserBack : TR_User;

type tv_score is array (integer range <>) of TR_score;
type TV_User is array (integer range <>) of TR_User;

--deux fenetres pour choisir la partie, puis jouer la partie.
Fpartie, FJeu, FRegleJeu , Ffin, Fenscore, FJScores, Fsauv : TR_Fenetre;
NewLine : constant Character := Character'Val (10);

E_choiceError : exception;

package p_score_IO is new sequential_IO (TR_score); use p_score_IO;
package p_User_IO is new sequential_IO (TR_User); use p_User_IO;


---------------------Corps

---------------------------usefull Proc&function--------------------------
function convertPiece(piece : in t_piece) return T_Couleur;
--{} => {renvoit la couleur T_Couleur correspondante à la couleur de t_piece}



--------------------------------------------------------------------------

procedure LancerScores;
----{} => {affiche la fenêtre des scores}

procedure fichversVect(f : in out p_score_IO.file_type; v : in out Tv_score);
--{f ouvert, f- = <>} => {copie des valeurs de f dans v}

procedure fichversVect(f : in out p_User_IO.file_type; v : in out TV_User); --NOTE fichversVect
  ----{f ouvert, f- = <>} => {copie des valeurs de f dans v}


function nbElem(f : in p_score_IO.file_type) return natural;
  ----{f ouvert, f- = <>} => {retourne le nombre d'élément du fichier f}

function nbElem(f : in p_User_IO.file_type) return natural; --NOTE nbelem
  ----{f ouvert, f- = <>} => {retourne le nombre d'élément du fichier f}

procedure Afficherscore(v : in out Tv_score; Fen : in out TR_Fenetre);
---- {} => {Affiche une fenêtre des scores}

function infstrict(a,b : TR_score; choix : in integer) return boolean;
--{} => {compare a et b retourne true si a<b}

procedure permut(a,b : in out TR_score);
--{infstrict => true } => {échange a et b de place dans le vecteur}


procedure tribulle(v : in out tv_score; choix : in integer);
--{v non trié} => {v trié suivant choix}


-----------------------------------------2

procedure LancerPartie(f : in out p_Piece_IO.file_type; partie:out integer; Quitter : out boolean);
--{} => {a affiché la fenetre Fpartie pour selectionner la partie}

---------------------------------------3

procedure InitGrid(Fen : in out TR_Fenetre; name : in string; X, Y, cote, ecart:in natural);
--{} => {a generer la grille de bouton sur la fenetre Fen, avec les attributs des boutons}

procedure MajAffichage(v : in TV_Virus; Fen : in out TR_Fenetre);
--{aucune case de v n'est vide} => {a mis a jour les couleurs des boutons de la fenetre Jeu en fonction de ce qu'il y a dans V}




procedure afficheLog(f: in out text_io.file_type; win : in out TR_Fenetre);
--{} => {enregistre chaque action dans le jeu pour le renvoyer sur la fenêtre}

procedure LancerJeu(v: in out tv_virus;
f : in out p_Piece_IO.file_type;
quitter : out boolean;
partieNum : in integer);
--{} => {a affiché la fenetre de jeu}

procedure BoutonF(v : in out TV_Virus;
f : in out p_Piece_IO.file_type;
Quitter : out boolean;
coul : in out t_piece;
win : in out TR_Fenetre;
partieNum : in integer);
--{} => {Fait fonctionner le jeu, jusqu'à la victoire}


---------------------------4

function calcscore(nbcoup, temps: in natural) return natural;
----{fin partie} => {retourne le score du joueur}

procedure LancerFin(nbcoup, temps : in natural; win : in out TR_Fenetre; f : in out p_Piece_IO.file_type; v : in out TV_Virus; partieNum : in integer);
--{} => {affiche une fenetre avec niveau precedent/suivant, Rejouer et les infos sur la partie terminée}


-------------------------5

procedure Regle1Block(v : in out TV_Virus; quitter: out Boolean);
--{} => {Pour le tuto, deplace la piece violette}

procedure Regle2Block(v:in out TV_Virus; quitter: out Boolean);
--{} => {Pour le tuto, deplace la piece rouge}

procedure LancerRegleJeu(f:in out p_Piece_IO.file_type);
--{} => {a afficher les regles du jeu dans une fenetre}

------------------------Scores
procedure ScoresFen; --NOTE ScoresFen
  ----{} => {affiche la fenêtre des scores}

------------------------Backup----------------------------------

procedure initVcoup(v: out TV_Coups);
--{} => {}


procedure LancerSauv(vSauv : in TV_Virus; Vcoups : in out TV_Coups; PosVc : in integer; f : in out p_Piece_IO.file_type); --NOTE LancerSauv
  ----{} => {Afficher un popup pour sauvegarder la partie}

function dicho(v : in tv_user; nom : in string) return integer;
--{} => {recherche nom dans v et renvoie un entier}


procedure vectdansfich(v : in tv_user;f : in out p_user_IO.file_type);
--{} => {met v dans f}

procedure affUser(Users:in TR_User);
--{} => {}

---------------------------------------------------------------------
end p_vuegraph;
