
LIBNAME Projet '/home/u63612557/Projet/';

/* import de la base et sélection des données de 2019*/
data projet.eff2019 ; 
	set projet.effectifs;
	where annee = 2019 ; 
run ; 


/* nettoyage dept pour merge */
data projet.eff2019;
	set projet.eff2019;
	if dept = '2A' THEN dept = "211";
	if dept = '2B' THEN dept = "212";
	dept = INPUT(dept, 3.);
run;

/* groupby des indiv par département et patho */
PROC SQL ;
	create table projet.dept_eff as
	Select patho_niv1, dept, sum(ntop) as ntop
	from projet.eff2019
	Group by patho_niv1, dept
	ORDER BY dept;
quit;

/* keep les patho non missing */
data projet.dept_eff; 
set projet.dept_eff; 
where patho_niv1 is not missing; 
run; 

/* keep les depeartement francais */
data projet.dept_eff; 
set projet.dept_eff; 
where dept NE "999"; 
run; 


/* encode la variable patho pour transpose */
%macro label_encode(dataset,out_dataset,var);
   proc sql noprint;
     select distinct(&var)
     into:val1-
     from &dataset;
 select count(distinct(&var))  into:mx from &dataset;
 quit;
 data &out_dataset;
     set &dataset;
   %do i=1 %to &mx;
     if &var="&&&val&i" then patho_encode=&i;
   %end;
   run;
%mend;
 
%label_encode(projet.dept_eff, projet.patho_dept_encode,  patho_niv1);

/* table des labels */
proc SQL;
	create table projet.label_patho as
	select patho_niv1, mean(patho_encode) as encoding_var
	from projet.patho_dept_encode
	group by patho_niv1;
quit;

/* eviter bug char non reconnus*/
data projet.patho_dept_encode;
	set projet.patho_dept_encode;
	drop patho_niv1;
run;


/* modif pour bien merge Corse */
data projet.pop_dept;
	set projet.pop_dept;
	if DEP = 'Corse-du-Sud' THEN CODDEP = 211;
	if DEP = 'Haute-Corse' THEN CODDEP = 212;
run;


/* merge et calcul déclas Améli par hab */
PROC SQL;
	create table projet.patho_dept_pct as
	SELECT a.dept, b.DEP as name, ntop/PTOT as eff_p_hab, patho_encode
	FROM projet.patho_dept_encode as a
	INNER JOIN projet.pop_dept as b on INPUT(a.dept, 3.)=b.CODDEP;
quit;
	

/* trasnposer long en wide */
proc transpose data=projet.patho_dept_pct out=patho_dept_transpose prefix=patho_encode_;
    by dept name;
    id patho_encode;
    var eff_p_hab;
run;

/* modalité parfois manquante, on supprime */
data projet.patho_dept_transpose;
	set projet.patho_dept_transpose;
	drop patho_encode_14;
run;

/* sous dataframe sans DOM (971-974) */
data projet.patho_dept_transpose_ssDOM;
	set projet.patho_dept_transpose;
	where input(dept, 3.) < 900;
run;

/* clean env */
proc delete data= Projet.patho_dept_pct 
				  Projet.patho_dept_encode 
				  Projet.eff2019 Projet.dept_eff; 
				  run;