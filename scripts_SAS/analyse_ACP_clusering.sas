LIBNAME Projet '/home/u63612557/Projet/';

/* K-means
 *
 * Code de la tâche généré par SAS Studio 3.8 
 *
 * création d'une macro perso
 */

%macro kmeans_pca_graph(dataset_desired, clust);
ods noproctitle;

/* standardize data */
proc stdize data=&dataset_desired. out=Work._std_ method=range;
	var patho_encode_:;
run;

/* kmeans algo */
proc fastclus data=Work._std_ maxclusters=&clust out=PROJET.PATHO_DEPT_KMEANS;
	var patho_encode_:;
run;

/* keep dept et cluster */
data projet.clust_dep;
	set PROJET.PATHO_DEPT_KMEANS;
	keep CLUSTER DEPT;
run;

/* clean env */
proc delete data=Work._std_;
run;

/* calcul PCA */
ODS GRAPHICS ON ;
ODS SELECT patternPlot ; 
proc princomp data=PROJET.PATHO_DEPT_KMEANS plots(only)=(scree) PLOTS=PATTERN(VECTOR) 
		out=PROJET.PATHO_DEPT_KMEANS_PCA;
	var patho_encode_:;
run;

/* scatter plot dept PCA */
ods graphics / reset width=10in height=7in imagemap;

proc sgplot data=PROJET.PATHO_DEPT_KMEANS_PCA;
	scatter x=Prin1 y=Prin2 / group=CLUSTER datalabel=name datalabelattrs=(size=7);
	xaxis grid label="Composante principale n°1";
	yaxis grid label="Composante principale n°2";
run;

ods graphics / reset;

proc sql;
	CREATE TABLE projet.Kmeans_centroids AS
	select CLUSTER, avg(patho_encode_1) as patho1, 
		   avg(patho_encode_2) as patho2,
		   avg(patho_encode_3) as patho3,
		   avg(patho_encode_4) as patho4,
		   avg(patho_encode_5) as patho5,
		   avg(patho_encode_6) as patho6,
		   avg(patho_encode_7) as patho7,
		   avg(patho_encode_8) as patho8,
		   avg(patho_encode_9) as patho9,
		   avg(patho_encode_10) as patho10,
		   avg(patho_encode_11) as patho11,
		   avg(patho_encode_12) as patho12,
		   avg(patho_encode_13) as patho13,
		   avg(patho_encode_15) as patho15,
		   avg(patho_encode_16) as patho16,
		   avg(patho_encode_17) as patho17
	 FROM projet.patho_dept_transpose as a
	 INNER JOIN projet.clust_dep as b on a.dept=b.dept
	 GROUP BY CLUSTER;
quit;

proc print data = projet.Kmeans_centroids;
run;
%mend;

*%KMEANS_pca_graph(projet.patho_dept_transpose_SSDOM, 4);
%KMEANS_pca_graph(projet.patho_dept_transpose, 5);


