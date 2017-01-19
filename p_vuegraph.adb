package body p_vuegraph is


procedure LancerPartie(f : in out p_Piece_IO.file_type ;partie:out integer; quitter : out boolean) is
--{} => {a affiché la fenetre Fpartie pour selectionner la partie}
  nombouton:string(1..2);
  I, J:integer;
begin --LancerPartie
  partie:=21; --initialisation de partie pour savoir si l'utilisateur en a choisi une
  quitter:=false;

  Fpartie:=DebutFenetre("Selection de la partie",700,700);
  AjouterBouton(Fpartie,"BoutonCommencer","Commencer !",225,650,70,50);
  AjouterBouton(Fpartie,"BoutonQuitter","Quitter",400,650,70,50); --(margeG, margeH, boutonL, boutonH)
  AjouterBouton(Fpartie,"BoutonTuto","Regles",313,650,70,50);

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
        quitter:=true;
      elsif Bouton="BoutonCommencer" and partie/=21 then
        CacherFenetre(Fpartie);
      elsif Bouton="BoutonCommencer" and partie=21 then
        ChangerTexte(Fpartie, "Info", "Selectionner une partie !");
      elsif bouton="BoutonTuto" then
        LancerRegleJeu(f);
      end if;
      exit when quitter or (Bouton="BoutonCommencer" and partie/=21);
    end testBouton;
  end loop;


end LancerPartie;


--------------------------Fin de la fenetre de lancement----------------------------

--------------------------Fenetre de fin-----------------------------------
procedure LancerFin(nbcoup : in integer; nom : in string) is
--{} => {affiche une fenetre avec niveau precedent/suivant, Rejouer et les infos sur la partie terminée}
begin
  Ffin:=DebutFenetre("Fin de partie",500,200);
  AjouterBouton(Ffin,"BoutonPrecedent","Niveau precedent",225,150,70,50);
  AjouterBouton(Ffin,"BoutonPrecedent","Niveau Suivant",500,150,70,50);
  AjouterBouton(Ffin,"BoutonQuitter","Quitter",400,650,70,50); --(margeG, margeH, boutonL, boutonH)
  AjouterBouton(Ffin,"BoutonRecommencer","Refaire le niveau",313,650,70,50);

  AjouterTexte(Ffin, "Info", "", 260, 20, 160, 20);
  FinFenetre(Ffin);

  MontrerFenetre(Ffin);
end LancerFin;

function convertPiece(piece : in t_piece) return T_Couleur is
--{} => {renvoit la couleur T_Couleur correspondante à la couleur de t_piece}

begin --convertPiece
  case piece is
    when rouge => return FL_RED;
    when turquoise => return FL_CYAN;
    when orange => return FL_DARKORANGE;
    when rose => return FL_MAGENTA;
    when marron => return FL_DARKTOMATO;
    when bleu => return FL_BLUE;
    when violet => return FL_DARKVIOLET;
    when vert => return FL_GREEN;
    when jaune => return FL_YELLOW;
    when blanc => return FL_WHITE;
    when vide => return FL_INACTIVE;
  end case;
end convertPiece;


------------------------------------------------------


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
      ChangerCouleurFond(Fen,nombouton,convertPiece(v(i,j)));
      if v(i,j)=blanc or v(i,j)=vide then
        ChangerEtatBouton(fen, nombouton, arret);
      else
        ChangerEtatBouton(fen, nombouton, marche);
      end if;

      if j/= T_col'succ(v'last(2)) then
        j := T_col'succ(j);
        if j/= T_col'succ(v'last(2)) then
          j := T_col'succ(j);
        end if;
      end if;
    end loop;
  end loop;
end MajAffichage;


------------------------------------------------------


procedure InitGrid(Fen : in out TR_Fenetre; name : in string; X, Y, cote, ecart:in natural) is
--{} => {a generé la grille de bouton correspondant au plateau de jeu sur la fenetre Fen, avec les attributs des boutons}
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
for j in TV_Virus'range(2) loop
  jpos:=T_col'pos(j)-64;
  AjouterTexte(Fen,character'image(j)(2..2), character'image(j)(2..2), (jpos-1)*(cote+ecart)+X+cote/(ecart-2), Y-30, 20, 20);
--TODO pour I !!
end loop;
end InitGrid;

--------------------Pour fenêtre principale-------------------------------

procedure BoutonF(v : in out TV_Virus;
                  f : in out p_Piece_IO.file_type;
                  Quitter : out boolean;
                  coul : in out t_piece;
                  win : in out TR_Fenetre) is
--{} => {}
  Dir: T_Direction;
  tempsdebut, tempsfin : time;
  nbmove, temps : natural;
  trscore : tR_score;
  fscore : p_score_IO.file_type;
begin
  tempsdebut := clock;
  Quitter := false;
  nbmove:=0;
    loop
    blockBouton:
      declare
        bouton : String := (AttendreBouton(win));
      begin
        ecrire("test3");
        ecrire_ligne(bouton);
        if bouton = "BoutonQuitter" then
          CacherFenetre(win);
          Quitter := true;
        elsif bouton = "BoutonTuto" then
          LancerRegleJeu(f);
        elsif bouton = "BoutonAnnuler" then
          if nbmove>0 then
            nbmove:=nbmove-1;
          --else

            --TODO MSG à mettre pour signaler que ce n'est pas possible
          end if;
        elsif Bouton = "hd" and (coul/=vide or coul/=blanc) then
          Dir := hd;
          if possible(v,coul, Dir) then
            Deplacement(v,coul, Dir);
            nbmove:=nbmove+1;
          end if;
        elsif Bouton = "hg" and (coul/=vide or coul/=blanc) then
          Dir := hg;
          if possible(v,coul, Dir) then
            Deplacement(v,coul, Dir);
            nbmove:=nbmove+1;
          end if;
        elsif Bouton = "bd" and (coul/=vide or coul/=blanc) then
          Dir := bd;
          if possible(v,coul, Dir) then
            Deplacement(v,coul, Dir);
            nbmove:=nbmove+1;
          end if;
        elsif Bouton = "bg" and (coul/=vide or coul/=blanc)  then
          Dir := bg;
          if possible(v,coul, Dir) then
            Deplacement(v,coul, Dir);
            nbmove:=nbmove+1;
          end if;
        else
          coul := v(integer'value(bouton(1..1)),bouton(2));
          ecrire(t_piece'image(coul));
        end if;
    end blockBouton;
    exit when Gueri(v) or quitter;
    MajAffichage(v,win);
  end loop;

  ----------------------fin de la partie / traitement du score---------------------------
  tempsfin := clock;
  temps := natural(tempsfin - tempsdebut);
  trscore.score := calcscore(nbmove, temps);
  trscore.niveau :=4; --TODO changer niveau

  ecrire_ligne(trscore.score);
  ---enregistrement dans le ficher
  if not exists("f_score.dat") then
    ecrire_ligne("création du fichier...");
    p_score_IO.create(fscore, out_file, "f_score.dat");
  else
    p_score_IO.open(fscore, p_score_IO.append_file, "f_score.dat");
  end if;
  write(fscore, trscore);
  close(fscore);
end boutonF;





--------------------ouvrir fenêtre principale-------------------------------
procedure LancerJeu(v: in out tv_virus;
                    f : in out p_Piece_IO.file_type;
                    quitter : out boolean) is --TODO et ne pas oublier de detecter la fin
--{} => {a affiché la fenetre de jeu}
-->> TODO nbcoup-------------------------------------------------
FJeu : TR_Fenetre;
hauteur, x, y, cote, ecart, boutonXY : natural;
coul : t_piece:= vide;
begin
  x := 50;
  y := 50;
  v(i).niveau;
  cote:= 50;
  ecart:= 5;
  hauteur := 25;
  boutonXY:=35;

  InitialiserFenetres;
  Fjeu:=DebutFenetre("AntiVirus",800,700);
  AjouterBoutonImage(Fjeu,"hg","",500,400,boutonXY,boutonXY);
  AjouterBoutonImage(Fjeu,"hd","",540,400,boutonXY,boutonXY);
  AjouterBoutonImage(Fjeu,"bg","",500,440,boutonXY,boutonXY);
  AjouterBoutonImage(Fjeu,"bd","",540,440,boutonXY,boutonXY);

  ChangerImageBouton(Fjeu, "hg", "resources/arhg.xpm");
  ChangerImageBouton(Fjeu, "hd", "resources/arhd.xpm");
  ChangerImageBouton(Fjeu, "bg", "resources/arbg.xpm");
  ChangerImageBouton(Fjeu, "bd", "resources/arbd.xpm");

  AjouterBouton(Fjeu,"BoutonQuitter","Quitter",145,650,70,50);
  AjouterBouton(Fjeu,"BoutonTuto","Regles",320,650,70,50);




  --AjouterTexte(Fjeu,"A", "A", 58, hauteur, 20, 20);
  --AjouterTexte(Fjeu,"B", "B", 93, hauteur, 20, 20);
  --AjouterTexte(Fjeu,"C", "C", 128, hauteur, 20, 20);
  --AjouterTexte(Fjeu,"D", "D", 162, hauteur, 20, 20);
  --AjouterTexte(Fjeu,"E", "E", 196, hauteur, 20, 20);
  --AjouterTexte(Fjeu,"F", "F", 230, hauteur, 20, 20);
  --AjouterTexte(Fjeu,"G", "G",
  AjouterTexte(Fjeu,"1", "1", 20, 60, 20, 20);
  AjouterTexte(Fjeu,"2", "2", 20, 100, 20, 20);
  AjouterTexte(Fjeu,"3", "3", 20, 140, 20, 20);
  AjouterTexte(Fjeu,"4", "4", 20, 180, 20, 20);
  AjouterTexte(Fjeu,"5", "5", 20, 220, 20, 20);
  AjouterTexte(Fjeu,"6", "6", 20, 260, 20, 20);
  AjouterTexte(Fjeu,"7", "7", 20, 300, 20, 20);

  InitGrid(FJeu, "", x, y, cote, ecart);
  FinFenetre(Fjeu);
  MontrerFenetre(Fjeu);
  MajAffichage(v, Fjeu);


  BoutonF(v, f,Quitter, coul, fjeu);
  --TODO Faire le lien avec la fin

end LancerJeu;



---------------------Pour tuto---------------------------------

procedure Regle1Block(v : in out TV_Virus; quitter: out Boolean) is
  task Regle1;  --pour afficher une magnifique animation qui s'arrete lorsqu'on appuis sur quitter ou continuer
  task body Regle1 is
  begin
    for i in 1..10 loop
      delay 1.0;
      Deplacement(v, violet, hg);
      MajAffichage(v, FRegleJeu);
      delay 1.0;
      Deplacement(v, violet, bd);
      MajAffichage(v, FRegleJeu);
    end loop;
  end Regle1;
  ---------------------------------------------------
begin
  quitter:=false;
  if Attendrebouton(FRegleJeu)="BoutonQuitter" then
    CacherFenetre(FRegleJeu);
    quitter:=true;
  end if;
  abort regle1; --permet d'arreter la tache pour continuer
end Regle1Block;


procedure Regle2Block(v:in out TV_Virus; quitter: out Boolean) is
  task Regle2;
  task body Regle2 is
  begin
    if Possible(v, violet, hg) then
      Deplacement(v, violet, hg);
      MajAffichage(v, FRegleJeu);
    end if;
    for i in 1..10 loop
      delay 1.0;
      Deplacement(v, rouge, hd);
      MajAffichage(v, FRegleJeu);
      delay 1.0;
      Deplacement(v, rouge, hd);
      MajAffichage(v, FRegleJeu);
      delay 1.0;
      Deplacement(v, rouge, bg);
      MajAffichage(v, FRegleJeu);
      delay 1.0;
      Deplacement(v, rouge, bg);
      MajAffichage(v, FRegleJeu);
    end loop;
  end Regle2;
  begin
    quitter:=false;
    if Attendrebouton(FRegleJeu)="BoutonQuitter" then
      CacherFenetre(FRegleJeu);
      quitter:=true;
    end if;
    abort regle2;
    while Possible(v, rouge, hd) loop
      ecrire(Possible(v, rouge, hd));
      Deplacement(v, rouge, hd);
      MajAffichage(v, FRegleJeu);
    end loop;
end Regle2Block;



procedure LancerRegleJeu(f:in out p_Piece_IO.file_type) is
--{f ouvert} => {a afficher les regles du jeu dans une fenetre}
  V:TV_Virus;
  Q:boolean;
begin
  reset(f, p_Piece_IO.in_file);

  FRegleJeu:=DebutFenetre("Regle du jeu",550,700);
  AjouterBouton(FRegleJeu,"BoutonContinuer","Continuer",145,650,70,50);
  AjouterBouton(FRegleJeu,"BoutonQuitter","Quitter",320,650,70,50); --(margeG, margeH, boutonL, boutonH)
  AjouterTexte(FRegleJeu, "Info","test", 170, 500, 200, 100);
  --AjouterBouton(FRegleJeu,nombouton,"",(jpos-1)*35+50,(I-1)*35+40,30,30); --la multiplication permet d'appliquer des ecarts entre les boutons et l'ajout, l'ecarts aux bords.
  InitGrid(FRegleJeu, "", 50, 40, 60, 5);
  FinFenetre(FRegleJeu);

  InitVect(v);
  CreeVectVirus(f,1, v);
  MontrerFenetre(FRegleJeu);
  MajAffichage(v, FRegleJeu);

  Changertexte(FRegleJeu, "Info", "Vous pouvez deplacer le groupe" & NewLine & "de couleur que vous voulez" & NewLine & "en cliquant dessus puis en " & NewLine & "utilisant les fleches");
  Regle1Block(v, q);

  if not q then
    Changertexte(FRegleJeu, "Info", "Vous vous deplacer en diagonale");
    Regle2Block(v, q);
    if not q then
      Changertexte(FRegleJeu, "Info", "Pour enfin faire sortir le virus rouge" & NewLine & "en haut a gauche et c'est gueri !!");
      while Possible(v, violet, bd) loop
        ecrire(Possible(v, violet, bd));
        Deplacement(v, violet, bd);
        MajAffichage(v, FRegleJeu);
      end loop;
      Deplacement(v, rouge, bg);
      Deplacement(v, rouge, hg);
      Deplacement(v, rouge, bg);
      Deplacement(v, rouge, hg);
      MajAffichage(v, FRegleJeu);

      if Attendrebouton(FRegleJeu)="BoutonContinuer" then
        Changertexte(FRegleJeu, "Info", "Fin du tutoriel, Appuyez" & NewLine & "sur continuer pour jouer.");
        if Attendrebouton(FRegleJeu)/="" then
          Cacherfenetre(FRegleJeu);
        end if;
      else
        Cacherfenetre(FRegleJeu);
      end if;
    end if;
  end if;
  --if Attendrebouton(FRegleJeu)/="BoutonQuitter" then
  --  ecrire("test");
  --end if;
end LancerRegleJeu;

-----------------------------------------Partie score------------------------------------------------------

function calcscore(nbcoup, temps : in natural) return natural is
----{nbcoup et temps} => {= resultat est le score}

begin
return natural(((1.0/float(nbcoup) + 1.0/float(temps)) * 150000000.0));
end calcscore;

function nbElem(f : in p_score_IO.file_type) return natural is
----{f ouvert, f- = <>} => {}
  nbelem : natural;
  i : TR_score;
begin
  nbelem := 1;
while not end_of_file(f) loop
  read(f,i);
  nbelem := nbelem+1;
end loop;
return nbelem;
end nbElem;

procedure fichversVect(f : in out p_score_IO.file_type; v : out Tv_score) is
i : integer;
begin
  reset(f, in_file);
  i := 0;
while not end_of_file(f) loop
  read(f,v(i));
  i := i+1;
end loop;
reset(f, in_file);
end fichversVect;



procedure Afficherscore(v : in Tv_score; Fen : in out TR_Fenetre; nomtxtasc : string) is
------ {} => {}
grosstring : string(1..10000);
petitstring : string(1..100);
begin
  for i in v'range loop
    petitstring := (v(i).nom & '|' & integer'image(v(i).score) & '|' & integer'image(v(i).niveau) & '|' & integer'image(Day(v(i).date)) & '/' & integer'image(Month(v(i).date)) & '/' & integer'image(Year(v(i).date)) & NewLine);

    grosstring(1..petitstring'last) := petitstring ;
    trscore.nom(petitstring'last+1..100):= (others => petitstring);
    --grosstring()
  end loop;
end Afficherscore;


procedure LancerScores(fen : in out TR_Fenetre; trscore : in out TR_score) is
----{} => {}
--Tsaisienom : string(1..15);
vertic : natural;
begin
  vertic := 50;
  InitialiserFenetres;
  fen:= DebutFenetre("SCORE",400,500);
  Ajouterchamp(fen, "saisienom","Saisir votre nom", "", 150, vertic, 100, 30);
  AjouterBouton(fen,"Bsaisienom","valider",300,vertic-10,50,50);
  AjouterTexteAscenseur(fen, "txtasc","","",50, vertic+50, 300, 400);

  FinFenetre(fen);
  MontrerFenetre(fen);

  loop
  declare
    bouton: string:=AttendreBouton(fen);
    nomsaisie : string := ConsulterContenu(fen,"saisienom");
    begin
    trscore.nom(1..nomsaisie'last) := nomsaisie ;
    trscore.nom(nomsaisie'last+1..15):= (others => ' ');
    trscore.date := clock;
    ecrire("Salut, ");
    ecrire(ConsulterContenu(fen,"saisienom")); ecrire_ligne("!");
    ecrire("Nom enregistrer voyons votre niveau!");
    exit when bouton="Bsaisienom";
    end;
  end loop;

end LancerScores;

-----------------------------------------fin score------------------------------------------------------



function infstrict(a,b : TR_score; choix : in integer) return boolean is
--{} => {}
begin
  if choix = 0 then
    return (a.nom <b.nom) or (a.nom = b.nom and a.score<b.score);
  elsif choix = 1 then
    return (a.score <b.score) or (a.score = b.score and a.nom<b.nom);
  elsif choix = 2 then
    return (a.date <b.date) or (a.date = b.date and a.score<b.score);
  elsif choix = 3 then
    return (a.niveau < b.niveau) or (a.niveau = b.niveau and a.score<b.score);
  else
    raise E_choiceError;
  end if;


end infstrict;

procedure permut(a,b : in out TR_score) is-- intervertis les deux éléments du vecteur pour les trier
--{} => {}
c : TR_score;
begin
  c := a;
  a:= b;
  b := c;
end permut;

procedure tribulle(v : in out tv_score; choix : in integer) is -- 0=>nom/score -- 1=>score/nom -- 2=>date/score --3=>niveau/score
--{v non trié} => {v trié suivant choix}
begin
  for i in v'range loop
    for j in reverse i+1..v'last loop
      if infstrict(v(i),v(j),choix) then
        permut(v(i),v(j));
      end if;
    end loop;
  end loop;
end tribulle;


end p_vuegraph;
