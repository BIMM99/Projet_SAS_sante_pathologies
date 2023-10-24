# Projet SAS - Analyse des données de prise en charge par l'Assurance maladie au niveau départemental

## Données

- [Base des effectif de patients par pathologie, sexe, classe d’âge et territoire (département, région)](https://data.ameli.fr/explore/dataset/effectifs/information/)
- [Population par département en 2019](https://www.insee.fr/fr/statistiques/6011075)

## Analyses présentes

- Statistiques descriptives de données
- Analyse en composante principale du nombre de prise en charge par habitant pour les 17 différentes pathologies listées par l'Assurance maladie
- *Clustering* des 94 départements métropolitains (hors Corse) sur la base de leur nombre de prise en charge par habitant vivant dans le département

## Résumé

- Possibilité de résumer plus de 85% de la variabilité totale de la prise en charge entre départements avec 3 composantes (de 17 variables initialement)
- Nette différences entre métropole et les territoires ultra-marins, d'où la nécessité de politiques adpatées (diabète aux Antilles, manque d'accès à l'infrastructure de soin en Guyane...)
- Opposition entre les départements urbains et les autres : les premiers font proportionnellement face à beaucoup moins de pathologies généralement associées à l'âge (cancer, dégénérescence...). L'inverse est vrai pour les soins associés à la maternité.
- 3 facteurs semblent influencer la prise en charge par habitant (possible appronfondissement de l'étude que nous avons fait):
    - le besoin de soin (structure d'âge principalement mais aussi les pathologies locales)
    - le recours au services de soin (certains territoires peuvent avoir un recours plus ou moins fort au service de santé)
    - l'offre de soin et son accessibilité 
