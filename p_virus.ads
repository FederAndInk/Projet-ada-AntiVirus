with sequential_IO; 
with p_esiut; use p_esiut;

package p_virus is

--------------- Types pour representer les pieces et la grille de jeu

	subtype T_Col is character range 'A'..'G';
	subtype T_Lig is integer range 1..7;
	type T_Piece is (rouge, turquoise, orange, rose, marron, bleu, violet, vert, jaune, blanc, vide);

	type TR_Piece is record
		colonne	:	T_Col;
		ligne	:	T_Lig;
		couleur	:	T_Piece range rouge..blanc;
	end record;

	---- Instanciation de sequential_IO pour le fichier de description de la grille
	package p_Piece_IO is new sequential_IO (TR_Piece); use p_Piece_IO;

	---- type pour le vecteur representant la grille
	type TV_Virus is array (T_lig,T_col) of T_Piece;

	---- type pour la direction des deplacements des pieces
	type T_Direction is (bg, hg, bd, hd);
	package p_Direction_IO is new p_enum(T_Direction); 

--------------- Creation et Affichage de la grille

procedure CreeVectVirus (f : in out file_type; nb : in integer; V :out TV_Virus);
-- {f (ouvert) contient des configurations initiales,
-- toutes les configurations se terminent par la position du virus rouge}
-- => {V a ete initialise par lecture dans f de la partie de numero nb}

procedure AfficheVectVirus (V : in TV_Virus);
-- {} => {Les valeurs du vecteur V sont affichees sur une ligne}

procedure AfficheGrille (V : in TV_Virus);
-- {} => {Le contenu du vecteur V est affiche dans une grille symbolisee
-- Les colonnes sont numerotees de A a G et les lignes sont numerotees de 1 a 7.
-- Dans chaque case : 	. = case vide
--			un chiffre = numero de la couleur de la piece presente dans la case
--			le caractere 'B' = piece blanche fixe
-- 			rien = pas une case}

--------------- Fonctions et procedures pour le jeu

function Gueri (V : in TV_Virus) return Boolean;
-- {} => {resultat = la piece rouge est prete a sortir (coin haut gauche)}

function Presente (V : in TV_Virus; Coul : in T_Piece) return Boolean;
-- {} => {resultat =  la piece de couleur Coul appartient a V}

function Possible (V : in TV_Virus; Coul : in T_Piece; Dir : in T_Direction) return Boolean;
-- {P appartient a la grille V} => {resultat = vrai si la piece de couleur Coul peut etre 
--                                             deplacee dans la direction Dir}

procedure Deplacement(V : in out TV_Virus; Coul : in T_Piece; Dir :in T_Direction);
-- {la piece de couleur Coul peut etre deplacee dans la direction Dir} 
--                                        => {V a ete mis a jour suite au deplacement}

end p_virus;

