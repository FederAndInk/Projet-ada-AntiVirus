package body p_vuegraph is



  -----------------------------------------Partie score------------------------------------------------------

procedure LancerScores is --NOTE LancerScores
  ----{} => {affiche la fenêtre des scores}
  vertic : natural;
  fscore : p_score_IO.file_type;
begin
  vertic := 50;
  InitialiserFenetres;
  Fenscore:= DebutFenetre("AntiVirus",400,500);
  Ajouterchamp(Fenscore, "saisienom","Saisir votre nom", "", 150, vertic, 100, 30);
  AjouterBouton(Fenscore,"Bsaisienom","valider",300,vertic-10,50,50);
  --AjouterBouton(Fenscore,"BoutonOk","Ok",275,vertic-10,50,50);
  AjouterTexteAscenseur(Fenscore, "txtScores","","",50, vertic+50, 300, 400);

  FinFenetre(Fenscore);
  MontrerFenetre(Fenscore);
  if not exists("f_score.dat") then
    ecrire_ligne("création du fichier...");
    p_score_IO.create(fscore, out_file, "f_score.dat");
    ChangerContenu(Fenscore, "txtScores", "Aucun score enregistre");
  else
    p_score_IO.open(fscore, p_score_IO.in_file, "f_score.dat");

    VecteurScore:
    declare
      vscore:Tv_score(1..nbElem(fscore));
    begin
      fichversVect(fscore, vscore);
      Afficherscore(vscore, Fenscore);
    end VecteurScore;

  end if;
  close(fscore);
  loop
    declare
      bouton: string:=AttendreBouton(Fenscore);
      Nom: string :=ConsulterContenu(Fenscore,"saisienom");
    begin
      if nom'length>10 then
        User.nom(1..10) := nom(1..10);
        UserBack.nom:=User.nom;
      else
        User.nom(1..nom'last) := nom;
        User.nom(nom'last+1..10):= (others => ' '); -- fonctionne quand meme avec 10 caracteres pile !
        UserBack.nom:=User.nom;
      end if;
      ecrire("Salut, ");
      ecrire(User.nom); ecrire_ligne("!");
      ecrire("Nom enregistrer voyons votre niveau!");
      exit when bouton="Bsaisienom";
    end;
  end loop;
  CacherFenetre(Fenscore);


end LancerScores;

procedure fichversVect(f : in out p_score_IO.file_type; v : in out Tv_score) is --NOTE fichversVect
  ----{f ouvert, f- = <>} => {copie des valeurs de f dans v}
  i : integer;
begin
  reset(f, in_file);
  i := v'first;
  while not end_of_file(f) loop
    read(f,v(i));
    i := i+1;
  end loop;
  reset(f, in_file);
end fichversVect;


function nbElem(f : in p_score_IO.file_type) return natural is --NOTE nbelem
  ----{f ouvert, f- = <>} => {retourne le nombre d'élément du fichier f}
  nbelem : natural;
  i : TR_score;
begin
  nbelem := 0;
  while not end_of_file(f) loop
    read(f,i);
    nbelem := nbelem+1;
  end loop;
  return nbelem;
end nbElem;


function infstrict(a,b : TR_score; choix : in integer) return boolean is --NOTE infstrict
--{} => {compare a et b retourne true si a<b}
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

procedure permut(a,b : in out TR_score) is-- intervertis les deux éléments du vecteur pour les trier NOTE permut
--{infstrict => true } => {échange a et b de place dans le vecteur}
c : TR_score;
begin
  c := a;
  a:= b;
  b := c;
end permut;

procedure tribulle(v : in out tv_score; choix : in integer) is -- 0=>nom/score -- 1=>score/nom -- 2=>date/score --3=>niveau/score NOTE permut
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


  procedure Afficherscore(v : in out Tv_score; Fen : in out TR_Fenetre) is --NOTE Afficherscore
---- {} => {Affiche une fenêtre des scores}
    grosstring : string(1..10000);
    lgtot, debs, lg : integer;
    i:integer:=V'first;
    present : string :="   Nom    |  Score  |niveau|    Date    " & NewLine;
  begin

    lgtot:=Present'last;
    grosstring(1..Present'last):=Present;
    tribulle(v, 1);
    lg:=0;
      while i<=v'last and lgtot<=(10000-lg) loop
        stringDyn:
        declare
          strInter : string:= (v(i).nom & '|' & integer'image(v(i).score) & "|    " & integer'image(v(i).niveau) & '|' & integer'image(Day(v(i).date)) & '/' & integer'image(Month(v(i).date)) & '/' & integer'image(Year(v(i).date)));
        begin
          lg:=strInter'last;
          debs:=lgtot+1;
          lgtot:=lgtot+lg;
          grosstring(debs..lgtot):=strInter(strInter'First..lg);
          lgtot:=lgtot+1;
          grosstring(lgtot):=NewLine;
          i:=i+1;
        end stringDyn;
      end loop;
        ecrire(grosstring(1..lgtot-1));
        ChangerContenu(Fen, "txtScores", grosstring(1..lgtot));
  end Afficherscore;




  -----------------------------------------fin score/debut------------------------------------------------------




--------------------------------Choix des niveaux----------------------------------------

procedure LancerPartie(f : in out p_Piece_IO.file_type ;partie:out integer; quitter : out boolean) is --NOTE LancerPartie
--{} => {a affiché la fenetre Fpartie pour selectionner la partie}
  nombouton:string(1..2);
  I, J:integer;
begin --LancerPartie
  partie:=21; --initialisation de partie pour savoir si l'utilisateur en a choisi une
  quitter:=false;

  Fpartie:=DebutFenetre("Selection de la partie",700,700);
  AjouterBouton(Fpartie,"BoutonTuto","Regles",225,650,70,50);
  AjouterBouton(Fpartie,"BoutonQuitter","Quitter",400,650,70,50); --(margeG, margeH, boutonL, boutonH)
  AjouterBouton(Fpartie,"BoutonCommencer","Commencer",313,650,70,50);

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



function convertPiece(piece : in t_piece) return T_Couleur is --NOTE convertPiece
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


procedure InitGrid(Fen : in out TR_Fenetre; name : in string; X, Y, cote, ecart:in natural) is --NOTE InitGrid
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
  end loop;
end InitGrid;

------------------------------------------------------

procedure MajAffichage(v : in TV_Virus; Fen : in out TR_Fenetre) is --NOTE MajAffichage
--{aucune case de v n'est vide} => {a mis a jour les couleurs des boutons de la fenetre Jeu en fonction de ce qu'il y a dans V}
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


------------------------Fichier log------------------------------------

procedure afficheLog(f: in out text_io.file_type; win : in out TR_Fenetre) is --NOTE afficheLog
--{} => {enregistre chaque action dans le jeu pour le renvoyer sur la fenêtre}
  slog : string(1..10000);
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
  while not end_of_file(f) and lgtot<=(10000-lg) loop
    get_line(f, s, lg);
    debs:=lgtot+1;
    lgtot:=lgtot+lg;
    slog(debs..lgtot):=s(1..lg);
    lgtot:=lgtot+1;
    slog(lgtot):=NewLine;
  end loop;
  ChangerContenu(win, "Info", slog(1..lgtot));
  reset(f, append_file);
end AfficheLog;



--------------------Pour fenêtre principale-------------------------------


--------------------ouvrir fenêtre principale-------------------------------
procedure LancerJeu(v: in out tv_virus;  --NOTE LancerJeu
                    f : in out p_Piece_IO.file_type;
                    quitter : out boolean;
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
  AjouterBouton(Fjeu,"BoutonScore", "Scores", 120,590,70,50);
  AjouterBouton(Fjeu,"BoutonQuitter","Quitter",50,640,70,50);
  AjouterBouton(Fjeu,"BoutonTuto","Regles",50,590,70,50);

  AjouterBouton(Fjeu,"BoutonAnnuler","Annuler",242,450,70,50);
  AjouterBouton(Fjeu,"BoutonReInit","Recommencer",165,450,70,50);

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

  BoutonF(v, f,Quitter, coul, fjeu, partieNum);
  --quitter:=true; >>Deprecated
end LancerJeu;


----------------------Fin fenetre principale----------------------------------


----------------------Boucle du jeu gere les boutons...
procedure BoutonF(v : in out TV_Virus; --NOTE BoutonF
                  f : in out p_Piece_IO.file_type;
                  Quitter : out boolean;
                  coul : in out t_piece;
                  win : in out TR_Fenetre;
                  partieNum : in integer) is
--{} => {Fait fonctionner le jeu, jusqu'à la victoire}
  Dir: T_Direction;
  tempsdebut, tempsfin : time;
  nbmove, temps : natural;
  fscore : p_score_IO.file_type;
  vcoup:TV_Coups;
  flog:text_io.file_type;

begin
  tempsdebut := clock;
  Quitter := false;
  User.niveau :=partieNum; --on sauvegarde le niveau au debut au cas d'une sauvegarde de partie;
  temps:=0;
  nbmove:=0;
  vcoup(nbmove):=v;
  --nbmove:=1;

  create(flog, out_file,"Partie.log");
  put(flog, "Debut du niveau " & integer'image(partieNum));


    loop
    blockBouton:
      declare
        bouton : String := (AttendreBouton(win));
      begin
        if bouton = "BoutonQuitter" then
          -- TODO faire une sauvegarde de l'etat du jeu :)
          LancerSauv(v, vcoup, nbmove, f);
          CacherFenetre(win);
          Quitter := true;
        elsif bouton = "BoutonTuto" then
          LancerRegleJeu(f);
        --elsif bouton="BoutonMenu" then
        --tempsfin := clock;
        --temps:=tempsfin-tempsdebut; --on met "en pause" le timer lorsqu'on est dans un menu
        --  --TODO menu
        --tempsdebut := clock;
        elsif bouton="BoutonScore" then
          tempsfin := clock;
          temps:=natural(tempsfin-tempsdebut); --on met "en pause" le timer lorsqu'on est dans un menu
          ScoresFen;
          tempsdebut := clock;
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
  close(flog);


  ----------------------fin de la partie / traitement du score-------
  tempsfin := clock;
  temps := temps + natural(tempsfin - tempsdebut);

  User.score := calcscore(nbmove, temps);

  User.date := clock;

  ecrire_ligne(User.score);


  ---enregistrement dans le ficher
  if not exists("f_score.dat") then
    ecrire_ligne("création du fichier...");
    p_score_IO.create(fscore, out_file, "f_score.dat");
  else
    p_score_IO.open(fscore, p_score_IO.append_file, "f_score.dat");
  end if;
  write(fscore, User);
  close(fscore);
  if not quitter then
    LancerFin(nbmove, temps, win, f, v, partieNum);
    quitter:=true;
  end if;
end boutonF;
-------------------------------------Fin de la Partie-----------------------------------




------------------fin + calcul du score

function calcscore(nbcoup, temps : in natural) return natural is --NOTE calcscore
----{nbcoup et temps} => {= resultat est le score}

begin
  if nbcoup/=0 and temps/=0 then
    return natural(((1.0/float(nbcoup) + 1.0/float(temps)) * 150000000.0));
  else
    return 00000000000;
  end if;
end calcscore;



--------------------------Fenetre de fin-----------------------------------
procedure LancerFin(nbcoup, temps : in natural; win : in out TR_Fenetre; f : in out p_Piece_IO.file_type; v : in out TV_Virus; partieNum : in integer) is --NOTE LancerFin
--{} => {affiche une fenetre avec niveau precedent/suivant, Rejouer et les infos sur la partie terminée}
  fin:boolean;
  numPropartie:integer;
begin
  Ffin:=DebutFenetre("Fin de partie",500,200);
  AjouterBouton(Ffin,"BoutonSuivant","Niveau" & NewLine & "Suivant",290,110,70,50);
  AjouterBouton(Ffin,"BoutonPrecedent","Niveau" & NewLine & "Precedent",140,110,70,50);
  AjouterBouton(Ffin,"BoutonNiveau", "Niveaux", 255,170,70,50);
  AjouterBouton(Ffin,"BoutonQuitter","Quitter",180,170,70,50); --(margeG, margeH, boutonL, boutonH)
  AjouterBouton(Ffin,"BoutonRecommencer","Refaire" & NewLine & "le niveau",215,110,70,50);
  AjouterBouton(Ffin,"BoutonScores", "Afficher" & NewLine & "les Scores", 300,50,65,40);

  AjouterTexte(Ffin, "Score", natural'image(User.score), 200, 40, 70, 60);
  AjouterTexte(Ffin, "Info", "Bravo " & User.nom & ", vous avez fini en " & natural'image(temps) & " secondes en " & integer'image(nbcoup) & " coup votre score est :", 20, 20, 480, 20);
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
      CacherFenetre(Ffin);
      CacherFenetre(Win);
      abort cligno;
      if bouton="BoutonPrecedent" and partieNum>1 then
        LancerJeu(v,f, fin, partieNum-1);
      elsif bouton="BoutonSuivant" and partieNum<20 then
        LancerJeu(v,f, fin, partieNum+1);
      elsif bouton="BoutonNiveau" then
        LancerPartie(f, numPropartie, fin);
        if not fin then
          LancerJeu(v,f, fin, numPropartie);
        end if;
      elsif bouton="BoutonQuitter" or fin then
        CacherFenetre(Ffin);
        CacherFenetre(win);
      elsif bouton="BoutonRecommencer" then
        LancerJeu(v,f, fin, partieNum);
      elsif bouton="BoutonScores" then
        ScoresFen;
      end if;
    end boutonC;
    abort cligno;
  end clignoScore;
end LancerFin;

---------------------------------------------------------------------------



---------------------Pour tuto---------------------------------

procedure Regle1Block(v : in out TV_Virus; quitter: out Boolean) is --NOTE Regle1Block
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


procedure Regle2Block(v:in out TV_Virus; quitter: out Boolean) is --NOTE Regle2Block
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



procedure LancerRegleJeu(f:in out p_Piece_IO.file_type) is --NOTE LancerRegleJeu
--{f ouvert} => {a afficher les regles du jeu dans une fenetre}
  V:TV_Virus;
  Q:boolean;
  boutonX, boutonY : integer;
begin
  reset(f, p_Piece_IO.in_file);
  boutonX:=30;
  boutonY:=27;
  FRegleJeu:=DebutFenetre("Regle du jeu",600,700);
  AjouterBouton(FRegleJeu,"BoutonQuitter","Quitter",145,650,70,50);
  AjouterBouton(FRegleJeu,"BoutonContinuer","Continuer",320,650,70,50); --(margeG, margeH, boutonL, boutonH)
  AjouterTexte(FRegleJeu, "Info","test", 170, 500, 200, 100);
  AjouterBoutonImage(FRegleJeu,"hg","",390,525,boutonX,boutonY);
  AjouterBoutonImage(FRegleJeu,"hd","",423,525,boutonX,boutonY);
  AjouterBoutonImage(FRegleJeu,"bg","",390,555,boutonX,boutonY);
  AjouterBoutonImage(FRegleJeu,"bd","",423,555,boutonX,boutonY);
  --AjouterBouton(FRegleJeu,nombouton,"",(jpos-1)*35+50,(I-1)*35+40,30,30); --la multiplication permet d'appliquer des ecarts entre les boutons et l'ajout, l'ecarts aux bords.
  InitGrid(FRegleJeu, "", 50, 40, 60, 5);
  FinFenetre(FRegleJeu);

  ChangerImageBouton(FRegleJeu, "hg", "resources/arhgI.xpm");
  ChangerImageBouton(FRegleJeu, "hd", "resources/arhd.xpm");
  ChangerImageBouton(FRegleJeu, "bg", "resources/arbg.xpm");
  ChangerImageBouton(FRegleJeu, "bd", "resources/arbd.xpm");


  InitVect(v);
  CreeVectVirus(f,1, v);
  MontrerFenetre(FRegleJeu);
  MajAffichage(v, FRegleJeu);

  Changertexte(FRegleJeu, "Info", "Vous pouvez deplacer le groupe" & NewLine & "de couleur que vous voulez" & NewLine & "en cliquant dessus puis en " & NewLine & "utilisant les fleches");
  Regle1Block(v, q);

  if not q then
    ChangerImageBouton(FRegleJeu, "hg", "resources/arhg.xpm");
    ChangerImageBouton(FRegleJeu, "hd", "resources/arhdII.xpm");
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


-------------------------Fin regles---------------------------------------

------------------------Scores window-------------------------------------
procedure ScoresFen is --NOTE ScoresFen
  ----{} => {affiche la fenêtre des scores}
  vertic : natural;
  fscore : p_score_IO.file_type;
begin
  vertic := 50;
  InitialiserFenetres;
  FJScores:= DebutFenetre("Score AntiVirus",400,500);
  AjouterBouton(FJScores,"BoutonOk","Ok",275,vertic-10,50,50);
  AjouterTexteAscenseur(FJScores, "txtScores","","",50, vertic+50, 300, 400);

  FinFenetre(FJScores);
  MontrerFenetre(FJScores);

  if not exists("f_score.dat") then
    ecrire_ligne("création du fichier...");
    p_score_IO.create(fscore, out_file, "f_score.dat");
    ChangerContenu(FJScores, "txtScores", "Aucun score enregistre");
  else
    p_score_IO.open(fscore, p_score_IO.in_file, "f_score.dat");

    VecteurScore:
    declare
      vscore:Tv_score(1..nbElem(fscore));
    begin
      fichversVect(fscore, vscore);
      Afficherscore(vscore, FJScores);
    end VecteurScore;

  end if;
  close(fscore);

  if AttendreBouton(FJScores)="BoutonOk" then
    CacherFenetre(FJScores);
  end if;
end ScoresFen;
--------------------------------------------------------------------------------
------------------------------Backup window-------------------------------------

procedure LancerSauv(vSauv : in TV_Virus; Vcoups : in TV_Coups; PosVc : in integer; f : in out p_Piece_IO.file_type) is --NOTE LancerSauv
  ----{} => {Afficher un popup pour sauvegarder la partie}
  --Tsaisienom : string(1..15);
  fscore : p_score_IO.file_type;
  v:TV_Virus;
begin
  InitialiserFenetres;
  Fsauv:= DebutFenetre("Sauvegarder ?",400,100);
  AjouterBouton(Fsauv,"BoutonOuiS","Oui",205,70,70,50);
  AjouterBouton(Fsauv,"BoutonNonS","Non",125,70,70,50);
  AjouterTexte(Fsauv, "txtSauv", "Voulez vous sauvegarder la partie en cours ?", 55, 20, 300, 20);
  FinFenetre(Fsauv);
  MontrerFenetre(Fsauv);
  reset(f, in_file);

  UserBack.niveau:=User.niveau;

  if AttendreBouton(Fsauv)="BoutonNonS" then
    InitVect(v);
    CreeVectVirus(f,UserBack.niveau, v);
    UserBack.partieSauv:=v;-- on ne sauvegarde rien, on prend la part
    UserBack.coupsSauv:=Vcoups;
    UserBack.coupPos:=0;
  else
    UserBack.partieSauv:=vSauv; --On sauvegarde le plateau
    UserBack.coupPos:=PosVc;
    UserBack.coupsSauv:=Vcoups;
  end if;

  CacherFenetre(Fsauv);

  --if not exists("f_score.dat") then
  --  ecrire_ligne("création du fichier...");
  --  p_score_IO.create(fscore, out_file, "f_score.dat");
  --  ChangerContenu(Fsauv, "txtScores", "Aucun score enregistre");
  --else
  --  p_score_IO.open(fscore, p_score_IO.in_file, "f_score.dat");
  --
  --  VecteurScore:
  --  declare
  --    vscore:Tv_score(1..nbElem(fscore));
  --  begin
  --    fichversVect(fscore, vscore);
  --    Afficherscore(vscore, Fsauv);
  --  end VecteurScore;
  --
  --end if;
  --close(fscore);

end LancerSauv;


--------------------------------------------------------------------------------

end p_vuegraph;
