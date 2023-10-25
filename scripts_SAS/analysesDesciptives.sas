LIBNAME Projet '/home/u63612557/Projet/';

/* import de la base et sélection des données de 2019*/
%let annee=2019;
data projet.eff2019 ; 
	set projet.effectifs;
	where annee = &annee ; 
run ; 



/* données par années (de 2015 à 2021) */
proc freq data = effectif;
table annee;
run; 

/* représentation graphique */
proc sql;
	create table MoyenneIndividus as
	select   annee
			, sum(ntop) as totalIndividus
	from projet.effectifs
	group by annee
;
quit;

proc sgplot data=MoyenneIndividus;
  scatter y=totalIndividus x=annee / datalabel=totalIndividus;
  yaxis label="Total Individus";
  xaxis label="Année";
  title "Nombre d'individus pris en charge par année, entre 2015 et 2021 ";
run;



/* Etude sur le genre */
title "représentation ciruculaire du nombre d'individus par genre";
proc gchart data=projet.eff2019;
    pie libelle_sexe;
run;
title;


/* frequence des patho, pour l annee 2019 */

title "distributation des pathologies, pour l'année &annee. .";
proc freq data=effectif order=freq;
	tables projet.eff2019  / nocum ;
run;
title;

