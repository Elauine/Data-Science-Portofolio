# Projet : Analyse des Ventes et du Churn dans les Magasins du Nord

### Réalisé par : Elauïne BERNARD  
**Devoir du cours Base de Données,  M2 Économétrie Appliquée**  
Université de Lille  
8 décembre 2023  

---

## Problématique

Le manager d'une grande enseigne a constaté que les résultats des magasins situés dans le nord de la France sont inférieurs à ceux des autres régions. En tant que data scientist, j'ai été sollicitée pour analyser cette situation, en me concentrant sur les ventes et le churn (taux d'attrition) des clients dans les magasins du nord. Les données sur les ventes, les produits et les clients de 2020 à 2023 ont été mises à ma disposition pour cette étude.

L'objectif de cette étude est de fournir des recommandations basées sur l'analyse des données, afin d'aider à la mise en place d'une stratégie de redressement.

---

## Plan de Travail

Le projet se divise en deux parties principales : **Python** pour la préparation et l'analyse des données, et **SQL** pour le calcul des indicateurs.

### Partie 1 : Python

1. **Création de la base de données de travail**  
   Utilisation de Python pour manipuler et organiser les données fournies.

2. **Traitement des données**  
   Nettoyage et préparation des données de vente et de churn pour l'analyse.

3. **Analyse des ventes et du churn**  
   - Analyse descriptive des ventes entre 2020 et 2023.
   - Analyse des comportements de churn chez les clients.

4. **Développement d'un modèle prédictif**  
   - Construction d'un modèle pour expliquer et prédire le churn des clients dans les magasins du nord.

### Partie 2 : SQL

1. **Création de la base de données sur SQL**  
   Importation et structuration des données dans une base de données SQL.

2. **Calcul des indicateurs pertinents**  
   - Requêtes SQL pour calculer des métriques clés telles que le taux de churn, les ventes moyennes, etc.

---

## Technologies Utilisées

- **Python** : 
  - Bibliothèques : Pandas, NumPy, Scikit-learn, Matplotlib, Seaborn
- **SQL** : utilisation de SQL dans Python avec sqlite3 

---

## Résultats Attendus

À l'issue de ce projet, plusieurs résultats sont attendus :
1. Une vue d'ensemble des ventes et du churn dans les magasins du nord de 2020 à 2023.
2. Des indicateurs permettant de comparer les performances des magasins.
3. Un modèle de prédiction du churn, fournissant des insights sur les facteurs influençant l'attrition des clients.
4. Des recommandations pour aider à la mise en place de stratégies d'amélioration.

---

## Auteurs

- **Elauïne BERNARD**  
  Economètre-statisticienne / Data Scientist

---

## Comment Exécuter le Projet

1. **Installation des dépendances** :  
   Clonez le repository et assurez-vous d'avoir les bibliothèques Python nécessaires installées :
   ```bash
   pip install -r requirements.txt
