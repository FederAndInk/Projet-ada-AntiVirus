with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with p_esiut; use p_esiut;
with ada.calendar; use ada.calendar;
procedure test2 is
FJeu : TR_Fenetre;
begin
  InitialiserFenetres;
  Fjeu:=DebutFenetre("AntiVirus",800,600);
  AjouterBouton(Fjeu,"hd","hd",500,400,50,50);
  AjouterBouton(Fjeu,"hg","hg",560,400,50,50);
  AjouterBouton(Fjeu,"bg","bg",500,460,50,50);
  AjouterBouton(Fjeu,"bd","bd",560,460,50,50);

  --AjouterTexte(Fjeu,"A", "A", 40, 40, 20, 20);
  --AjouterTexte(Fjeu,"B", "B", 80, 40, 20, 20);
  --AjouterTexte(Fjeu,"C", "C", 120, 40, 20, 20);
  --AjouterTexte(Fjeu,"D", "D", 160, 40, 20, 20);
  --AjouterTexte(Fjeu,"E", "E", 200, 40, 20, 20);
  --AjouterTexte(Fjeu,"F", "F", 240, 40, 20, 20);
  --AjouterTexte(Fjeu,"G", "G", 280, 40, 20, 20);
  --AjouterTexte(Fjeu,"1", "1", 20, 60, 20, 20);
  --AjouterTexte(Fjeu,"2", "2", 20, 100, 20, 20);
  --AjouterTexte(Fjeu,"3", "3", 20, 140, 20, 20);
  --AjouterTexte(Fjeu,"4", "4", 20, 180, 20, 20);
  --AjouterTexte(Fjeu,"5", "5", 20, 220, 20, 20);
  --AjouterTexte(Fjeu,"6", "6", 20, 260, 20, 20);
  --AjouterTexte(Fjeu,"7", "7", 20, 300, 20, 20);

while i < v'last(1) loop
  AjouterTexte(Fjeu, , , x, 40, 20, 20);
  x := x+40;
end loop;







  FinFenetre(Fjeu);
  MontrerFenetre(Fjeu);
  if AttendreBouton(Fjeu) = "BoutonValider"  then
    CacherFenetre(Fjeu);
  end if;

end test2;
