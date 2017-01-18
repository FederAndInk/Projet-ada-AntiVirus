with p_vuegraph; use p_vuegraph;
with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with p_esiut; use p_esiut;
with ada.calendar; use ada.calendar;
with p_virus; use p_virus;
with text_io; use p_virus.p_Piece_IO;
use p_virus.p_Direction_IO, p_virus.p_Pieceenum_IO;

procedure bcontrol is
FJeu : TR_Fenetre;
hauteur, x, y, cote, ecart : natural;
v_grille : tv_virus;
Dir:= T_Direction;
pieceselect : integer;
begin
x := 50;
y := 40;
cote:= 30;
ecart:= 5;
hauteur := 25;

  InitialiserFenetres;
  Fjeu:=DebutFenetre("AntiVirus",800,600);
  AjouterBouton(Fjeu,"hd","hd",500,400,50,50);
  AjouterBouton(Fjeu,"hg","hg",560,400,50,50);
  AjouterBouton(Fjeu,"bg","bg",500,460,50,50);
  AjouterBouton(Fjeu,"bd","bd",560,460,50,50);

  AjouterTexte(Fjeu,"A", "A", 58, hauteur, 20, 20);
  AjouterTexte(Fjeu,"B", "B", 93, hauteur, 20, 20);
  AjouterTexte(Fjeu,"C", "C", 128, hauteur, 20, 20);
  AjouterTexte(Fjeu,"D", "D", 162, hauteur, 20, 20);
  AjouterTexte(Fjeu,"E", "E", 196, hauteur, 20, 20);
  AjouterTexte(Fjeu,"F", "F", 230, hauteur, 20, 20);
  AjouterTexte(Fjeu,"G", "G", 264, hauteur, 20, 20);
  AjouterTexte(Fjeu,"1", "1", 20, 60, 20, 20);
  AjouterTexte(Fjeu,"2", "2", 20, 100, 20, 20);
  AjouterTexte(Fjeu,"3", "3", 20, 140, 20, 20);
  AjouterTexte(Fjeu,"4", "4", 20, 180, 20, 20);
  AjouterTexte(Fjeu,"5", "5", 20, 220, 20, 20);
  AjouterTexte(Fjeu,"6", "6", 20, 260, 20, 20);
  AjouterTexte(Fjeu,"7", "7", 20, 300, 20, 20);

  InitGrid(FJeu, "", x, y, cote, ecart);
--for i in 1..7 loop
--  AjouterTexte(Fjeu, T_col'(i), T_col'(i), x, 40, 20, 20);
--  x := x+40;
--end loop;



  FinFenetre(Fjeu);
  MontrerFenetre(Fjeu);
  if AttendreBouton(Fjeu) = "hd"  then
    Dir := hd;
    if possible(v_grille,ReplaceCoul(pieceselect), Dir) then
      Deplacement(v_grille,ReplaceCoul(pieceselect), Dir)
    end if;

  end if;
  if AttendreBouton(Fjeu) = "hg"  then
    Dir := hg;
    if possible(v_grille,ReplaceCoul(pieceselect), Dir) then
      Deplacement(v_grille,ReplaceCoul(pieceselect), Dir)
    end if;

  end if;
  if AttendreBouton(Fjeu) = "bd"  then
    Dir := bd;
    if possible(v_grille,ReplaceCoul(pieceselect), Dir) then
      Deplacement(v_grille,ReplaceCoul(pieceselect), Dir)
    end if;

  end if;
  if AttendreBouton(Fjeu) = "bg"  then
    Dir := bg;
    if possible(v_grille,ReplaceCoul(pieceselect), Dir) then
      Deplacement(v_grille,ReplaceCoul(pieceselect), Dir)
    end if;

  end if;

end bcontrol;
