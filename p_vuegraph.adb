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
procedure LancerFin(nbcoup : in natural; nom : in string; temps : in natural; win : in out TR_Fenetre) is --TEMP add the tr here
--{} => {affiche une fenetre avec niveau precedent/suivant, Rejouer et les infos sur la partie terminée}
begin
  Ffin:=DebutFenetre("Fin de partie",500,200);
  AjouterBouton(Ffin,"BoutonPrecedent","Niveau" & NewLine & "precedent",290,110,70,50);
  AjouterBouton(Ffin,"BoutonSuivant","Niveau" & NewLine & "Suivant",140,110,70,50);
  AjouterBouton(Ffin, "BoutonNiveau", "Niveaux", 255,170,70,50);
  AjouterBouton(Ffin,"BoutonQuitter","Quitter",180,170,70,50); --(margeG, margeH, boutonL, boutonH)
  AjouterBouton(Ffin,"BoutonRecommencer","Refaire" & NewLine & "le niveau",215,110,70,50);
  AjouterTexte(Ffin, "Score", "2400000", 200, 65, 150, 60);
  AjouterTexte(Ffin, "Info", "Bravo " & nom & ", vous avez fini en " & natural'image(temps) & " secondes et " & integer'image(nbcoup) & " votre est score est :", 20, 20, 480, 20);
  FinFenetre(Ffin);
  ChangerTailleTexte(Ffin, "Score", 48);
  MontrerFenetre(Ffin);

  clignoScore:
  declare
    task cligno;
    task body cligno is
    begin
      while true loop --TODO trouver une autre condition
        for i in FL_COLOR loop
          ChangerCouleurTexte(Ffin, "Score", i);
          delay 0.2;
        end loop;
      end loop;
    end cligno;
  begin
    boutonC:
    declare
      bouton:string:=Attendrebouton(Ffin);
    begin
      if bouton="BoutonPrecedent" then
        --TODO bouton 
      elsif bouton="BoutonSuivant" then

      elsif bouton="BoutonNiveau" then

      elsif bouton="BoutonQuitter" then
        CacherFenetre(Ffin);
      elsif bouton="BoutonRecommencer" then
      end if;
      CacherFenetre(Ffin);
    end boutonC;

  end clignoScore;
end LancerFin;

---------------------------------------------------------------------------

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


-----------------------Graphique-------------------------------


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
  AjouterTexte(Fen,character'image(j)(2..2), character'image(j)(2..2), (jpos-1)*(cote+ecart)+X+cote/(ecart-ecart/2), Y-30, 20, 20);
end loop;
for i in TV_Virus'range(1) loop
  AjouterTexte(Fen,integer'image(i)(2..2), integer'image(i)(2..2), X-20,(i-1)*(cote+ecart)+Y+cote/(ecart-ecart/2), 20, 20);
  ecrire_ligne(cote+ecart+40);
end loop;
end InitGrid;


------------------------Fichier log------------------------------------
procedure afficheLog(f: in out text_io.file_type; win : in out TR_Fenetre) is
--{} => {}
  slog : string(1..1000);
  s:string(1..40);
  lg, lgtot, debs:integer;
begin --log
  reset(f, in_file);
  lgtot:=1;
  if not end_of_file(f) then
    get_line(f, s, lg);
    slog(1..lg+1):=s(1..lg) & NewLine;
    lgtot:=lgtot+lg;
  end if;
  while not end_of_file(f) and lgtot<=(1000-lg) loop
    get_line(f, s, lg);
    debs:=lgtot+1;
    lgtot:=lgtot+lg;
    ecrire_ligne(debs);
    ecrire_ligne(lgtot);
    ecrire_ligne(lg);
    slog(debs..lgtot):=s(1..lg);
    lgtot:=lgtot+1;
    slog(lgtot):=NewLine;
  end loop;
  ecrire_ligne(slog);
  ChangerContenu(win, "Info", slog(1..lgtot));
  reset(f, append_file);
end AfficheLog;



--------------------Pour fenêtre principale-------------------------------

procedure BoutonF(v : in out TV_Virus;
                  f : in out p_Piece_IO.file_type;
                  Quitter : out boolean;
                  coul : in out t_piece;
                  win : in out TR_Fenetre;
                  nbmove: out integer;
                  partieNum: in integer;
                  temps : out natural) is
--{} => {}
  Dir: T_Direction;
  vcoup:TV_Coups;
  tempsDeb, tempsFin : time;
  flog:text_io.file_type;
begin
  Quitter := false;
  nbmove:=0;
  vcoup(nbmove):=v;
  nbmove:=1;
  tempsDeb:=clock;
  create(flog, out_file,"Partie.log");
  put(flog, "Debut du niveau " & integer'image(partieNum));


    loop
    blockBouton:
      declare
        bouton : String := (AttendreBouton(win));
      begin
        --ecrire(Hist);
        ecrire_ligne(bouton);
        if bouton = "BoutonQuitter" then
          CacherFenetre(win);
          Quitter := false;
        elsif bouton = "BoutonTuto" then
          LancerRegleJeu(f);
        elsif bouton = "BoutonAnnuler" then
          if nbmove>1 then
            nbmove:=nbmove-1;
            --ChangerContenu(win, "Info", "Deplacement" & integer'image(nbmove) & " annule");
            put(flog, "Deplacement" & integer'image(nbmove) & " annule");
            InitVect(v);
            v:=vcoup(nbmove-1);
          else
            put(flog, "Impossible de revenir en arriere");
          end if;
        elsif bouton = "BoutonReInit" then
          nbmove:=0;
          put(flog, "Recommencement du niveau : " & integer'image(partieNum));
          InitVect(v);
          CreeVectVirus(f,partieNum, v);
        elsif Bouton = "hd" and (coul/=vide or coul/=blanc) then
          Dir := hd;
          if possible(v,coul, Dir) then
            Deplacement(v,coul, Dir);
            vcoup(nbmove):=v;
            nbmove:=nbmove+1;
            put(flog, "Deplacement vers le Haut Droit");
          else
            put(flog, "Deplacement Impossible");
          end if;
        elsif Bouton = "hg" and (coul/=vide or coul/=blanc) then
          Dir := hg;
          if possible(v,coul, Dir) then
            Deplacement(v,coul, Dir);
            vcoup(nbmove):=v;
            nbmove:=nbmove+1;
            put(flog, "Deplacement vers le Haut Gauche");
          else
            put(flog, "Deplacement Impossible");
          end if;
        elsif Bouton = "bd" and (coul/=vide or coul/=blanc) then
          Dir := bd;
          if possible(v,coul, Dir) then
            Deplacement(v,coul, Dir);
            vcoup(nbmove):=v;
            nbmove:=nbmove+1;
            put(flog, "Deplacement vers le Bas Droit");
          else
            put(flog, "Deplacement Impossible");
          end if;
        elsif Bouton = "bg" and (coul/=vide or coul/=blanc)  then
          Dir := bg;
          if possible(v,coul, Dir) then
            Deplacement(v,coul, Dir);
            vcoup(nbmove):=v;
            nbmove:=nbmove+1;
            put(flog, "Deplacement vers le Bas Gauche");
          else
            put(flog, "Deplacement Impossible");
          end if;
        else
          coul := v(integer'value(bouton(1..1)),bouton(2));
          put(flog, "Selection de la piece de couleur " & t_piece'image(coul));
        end if;
    end blockBouton;
    MajAffichage(v,win);
    afficheLog(flog, win);
    exit when Gueri(v) or quitter;
  end loop;
  tempsFin:=clock;
  temps:=natural(tempsFin-tempsDeb);

  LancerFin(nbcoup, nom, temps);--TODO regarder ce que fait git
end boutonF;
--------------------ouvrir fenêtre principale-------------------------------
procedure LancerJeu(v: in out tv_virus;
                    f : in out p_Piece_IO.file_type;
                    quitter : out boolean;
                    nbmove : out integer;
                    temps : out natural;
                    partieNum : in integer) is
--{} => {a affiché la fenetre de jeu}
FJeu : TR_Fenetre;
hauteur, x, y, cote, ecart, boutonX, boutonY : natural;
coul : t_piece:= vide;
flog:text_io.file_type;
begin
  x := 50;
  y := 50;
  cote:= 50;
  ecart:= 5;
  hauteur := 25;
  boutonX:=30;
  boutonY:=27;
  -------------------------dessin fenetre---------
  InitialiserFenetres;
  Fjeu:=DebutFenetre("AntiVirus Niveau : " & integer'image(partieNum) ,800,700);
  AjouterBoutonImage(Fjeu,"hg","",490,367,boutonX,boutonY);
  AjouterBoutonImage(Fjeu,"hd","",523,367,boutonX,boutonY);
  AjouterBoutonImage(Fjeu,"bg","",490,397,boutonX,boutonY);
  AjouterBoutonImage(Fjeu,"bd","",523,397,boutonX,boutonY);

  ChangerImageBouton(Fjeu, "hg", "resources/arhg.xpm");
  ChangerImageBouton(Fjeu, "hd", "resources/arhd.xpm");
  ChangerImageBouton(Fjeu, "bg", "resources/arbg.xpm");
  ChangerImageBouton(Fjeu, "bd", "resources/arbd.xpm");

  AjouterBouton(Fjeu,"BoutonMenu", "Menu", 120,640,70,50);
  AjouterBouton(Fjeu,"BoutonQuitter","Quitter",50,640,70,50);
  AjouterBouton(Fjeu,"BoutonAnnuler","Annuler",242,450,70,50);
  AjouterBouton(Fjeu,"BoutonReInit","Recommencer",165,450,70,50);
  AjouterBouton(Fjeu,"BoutonTuto","Regles",50,590,70,50);

  AjouterTexteAscenseur(Fjeu, "Info", "Historique","", 500, 45, 270, 270);

  AjouterHorloge(Fjeu, "clock", "",600 ,550 ,150, 150);

  InitGrid(FJeu, "", x, y, cote, ecart);
  FinFenetre(Fjeu);
  -------------------------fin dessin fenetre---------
  ChangerContenu(FJeu, "Info", "Debut du niveau " & integer'image(partieNum));
  InitVect(v);
  CreeVectVirus(f,partieNum, v);
  MontrerFenetre(Fjeu);
  MajAffichage(v, Fjeu);
  BoutonF(v, f,Quitter, coul, fjeu, nbmove, partieNum, temps);
  --TODO Faire le lien avec la fin

end LancerJeu;


----------------------Fin fenetre principale----------------------------------
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


procedure LancerScores(f: in out p_score_IO.file_type) is
----{} => {}

begin
  Fscore:=DebutFenetre("SCORE",400,600);--TODO Affichage texte ascenseur pause tant que les tris ne sont pas prêt

  Ajouterchamp(Fscore, "saisienom","Saisir votre nom", "Moins de 15 caractère...", 500, 400, 50, 30);
  AjouterBouton(Fscore,"boutonValdier","valider",500,400,50,50);



  FinFenetre(Fscore);
  MontrerFenetre(Fscore);
  if  AttendreBouton(Fscore)="" then
    ecrire("we did it!");
  end if;

end LancerScores;

-----------------------------------------fin score------------------------------------------------------


function infstrict(a,b : TR_score) return boolean is
--{} => {}
begin
  return (a.nom <b.nom) or (a.nom = b.nom and a.score<b.score);
end infstrict;

procedure permut(a,b : in out TR_score) is
--{} => {}
c : TR_score;
begin
  c := a;
  a:= b;
  b := c;
end permut;

procedure trinom(v : in out tv_score) is
--{} => {}
begin
  for i in v'range loop
    for j in reverse i+1..v'last loop
      if infstrict(v(i),v(j)) then
        permut(v(i),v(j));
      end if;
    end loop;
  end loop;
end trinom;

--procedure triscore
--procedure tridate
--procedure triniveau

--procedure triVect(f : in out p_Piece_IO.file_type; V : in out TR_score) is
----{} => {}
--
--begin
--ecrire("bjr");
--
--
--end triVect;

end p_vuegraph;
