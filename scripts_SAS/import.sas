
FILENAME REFFILE '/home/u63612557/Projet/raw_data/effectifs.csv';
LIBNAME Projet '/home/u63612557/Projet/';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
		replace
	OUT=Projet.effectifs;
	delimiter=';';
	GETNAMES=YES;
RUN;
PROC IMPORT DATAFILE='/home/u63612557/Projet/raw_data/pop_dep_2019.csv'
	DBMS=CSV
		replace
	OUT=Projet.pop_dept;
	delimiter=';';
	GETNAMES=YES;
RUN;


