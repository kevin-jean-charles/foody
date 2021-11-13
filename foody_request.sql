#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# I- Requêtage simple:
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# I.1- Requêtage simple
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1 
SELECT * FROM Produit 
ORDER BY prixUnit LIMIT 10;

# 2 
SELECT * FROM produit 
ORDER BY prixUnit DESC LIMIT 3;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# I.2- Restriction
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------

#1 
SELECT * FROM Client 
WHERE Ville = 'Paris' AND Fax IS NULL;

#2 
SELECT * FROM Client 
WHERE Pays IN ('France','Germany','Canada');

#3
SELECT * FROM Client WHERE Societe LIKE '%restaurant%';

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# I.3- Projection
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1 
SELECT DISTINCT Descriptionn, NomCateg  
FROM Categorie;

# 2 
SELECT DISTINCT Pays, Ville 
FROM Client 
ORDER BY Pays, Ville DESC;

# 3
SELECT DISTINCT Societe, Contact, Ville FROM Fournisseur 
WHERE Pays = 'France'
ORDER BY Ville;

# 4 
SELECT RefProd AS Reference_du_produit, UCASE(NomProd) AS Nom_du_produit  
FROM Produit
WHERE NoFour = 8 AND PrixUnit BETWEEN 10 AND 100;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# II- Calculs et Fonction :
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# II.1- Calculs arithmétiques
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT PrixUnit, Remise, Qte, PrixUnit*(Remise*100)/100 AS Montant_Remise, (prixUnit - PrixUnit*(Remise*100)/100) * Qte AS Montant_TT 
FROM DetailCommande
WHERE NoCom = 10251;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# II.2- Traitement conditionnel
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT
CASE 
    WHEN Indisponible = TRUE THEN 'Produit non disponible'
    ELSE 'Produit disponible'
END AS disponible
FROM produit;

SELECT prod.NomProd,IF(prod.Indisponible = 0 , "Produit Disponible","Produit Indisponible") AS Disponibility
FROM produit AS prod; 

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# II.3- Fonctions sur chaînes de caractères
#-----------------------------------------
SELECT 
    CONCAT(Adresse,' ', CodePostal,' ',Ville,' ', Pays) AS Adresse_complete,
    SUBSTRING(CodeCli, length(CodeCli)-1, 2) AS CodeCli_substr,
    LCASE(Societe) AS Societe_lowercase,
    REPLACE(Fonction, 'Owner', 'Freelance') AS Fonction
FROM Client
WHERE Fonction LIKE '%manager%';

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# II.4- Fonctions sur les dates
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1
SELECT *, 
IF(WEEKDAY(DateCom) < 5, DATE_FORMAT(DateCom, "%W"), 'weekend') DateCom
FROM commande;

# 2
SELECT *,  
    DateCom,
    DATEDIFF( ALivAvant, DateCom ), 
    DATE_ADD(DateCom, INTERVAL 1 MONTH),
FROM Commande
LIMIT 3;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# III- Aggrégats
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# III.1- Dénombrements
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1 
SELECT COUNT(Fonction) AS nb_Sales_Manager FROM Employe 
WHERE Fonction = 'Sales Manager';

# 2 
SELECT COUNT(CodeCateg) FROM Produit
WHERE CodeCateg = 1 AND NoFour IN (1,18);

# 3 
SELECT COUNT(DISTINCT PaysLiv) FROM Commande;

# 4 
SELECT COUNT(*) FROM Commande
WHERE DateCom LIKE '%2006-08%';

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# III.2- Calculs statistiques simples
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1
SELECT MIN(Portt), MAX(Portt), AVG(Portt) 
FROM Commande
WHERE CodeCli = 'QUICK';

# 2
SELECT NoMess, SUM(Portt) AS 'Frais de port'
FROM Commande
GROUP BY NoMess;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# III.3- Agrégats selon attribut(s)
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1
SELECT Fonction, COUNT(Fonction) AS 'Employe par fonction' 
FROM Employe 
GROUP BY Fonction;


# 2
SELECT NoFour,  COUNT(DISTINCT CodeCateg) AS 'nbre categories de produit', CodeCateg
FROM Produit
GROUP BY NoFour;

# 3 
SELECT  NoFour, AVG(PrixUnit) 'prix moyen', CodeCateg 
FROM Produit
GROUP BY (NoFour);

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# III.4- Restriction sur agrégats
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1
SELECT NoFour, COUNT(RefProd) FROM Produit 
GROUP BY NoFour
HAVING COUNT(RefProd) = 1;

# 2 
SELECT  NoFour, CodeCateg, COUNT(DISTINCT CodeCateg) AS nbre_cat
FROM Produit 
GROUP BY NoFour
HAVING nbre_cat = 1;

# 3
SELECT NoFour, PrixUnit, MAX(PrixUnit)  FROM Produit
GROUP BY NoFour
HAVING MAX(PrixUnit) > 50;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# IV- Jointures:
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# IV.1- Jointures naturelles
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1 
SELECT * FROM Produit
NATURAL JOIN Fournisseur;

# 2 
SELECT * FROM Client
NATURAL JOIN Commande
WHERE Societe LIKE '%Lazy%';


# 3 
SELECT Messager.NomMess , COUNT(*) AS nb_commande FROM Commande
NATURAL JOIN Messager 
GROUP BY Messager.NomMess;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# IV.2- Jointures internes
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1 
SELECT * FROM Produit
INNER JOIN Fournisseur
WHERE Produit.NoFour = Fournisseur.NoFour;

# 2 
SELECT * FROM Client
INNER JOIN Commande
WHERE Societe LIKE '%Lazy%' AND Client.CodeCli = Commande.CodeCli;

# 3 
SELECT Messager.NomMess , COUNT(*) AS nb_commande FROM Commande
INNER JOIN Messager 
WHERE Commande.NoMess = Messager.NoMess
GROUP BY Messager.NomMess;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# IV.3- Jointures externes
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1
SELECT Produit.NomProd, COUNT(NoCom) FROM Produit 
LEFT OUTER JOIN DetailCommande
ON Produit.RefProd = DetailCommande.RefProd
GROUP BY Produit.RefProd;

# 2 
SELECT Produit.NomProd, COUNT(NoCom) FROM Produit 
LEFT OUTER JOIN DetailCommande
ON Produit.RefProd = DetailCommande.RefProd
GROUP BY Produit.RefProd
HAVING COUNT(NoCom) = 0;

# 3 
SELECT Employe.NoEmp, Nom, Prenom
FROM Employe
LEFT JOIN Commande
ON Commande.NoEmp = Employe.NoEmp
WHERE Commande.NoEmp IS NULL
GROUP BY Employe.NoEmp;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# IV.4- Jointures à la main
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1
SELECT Produit.NomProd, Fournisseur.Societe FROM Fournisseur, Produit
WHERE Fournisseur.NoFour = Produit.NoFour;

# 2
SELECT * FROM Client, Commande
WHERE Societe LIKE '%Lazy%' AND Client.CodeCli = Commande.CodeCli;


# 3
SELECT Messager.NomMess, COUNT(*)  
FROM Commande, Messager 
GROUP BY Messager.NomMess;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# V- Sous-requêtes
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# V.1- Sous-requêtes


# 1
SELECT Nom, Prenom
FROM Employe
WHERE NoEmp NOT IN (
    SELECT NoEmp 
    FROM Commande);

# 2
SELECT COUNT(*)
FROM Produit
WHERE NoFour = (
    SELECT NoFour
    FROM Fournisseur
    WHERE Societe = "Mayumis");

# 3
SELECT COUNT(*)
FROM Commande
WHERE NoEmp IN (
    SELECT NoEmp
    FROM Employe
    WHERE RendCompteA = (
        SELECT NoEmp
        FROM Employe
        WHERE Nom = "Buchanan"
        AND Prenom = "Steven"));

#-------------------------------
# V.2- Opérateur EXISTS
#-------------------------------

# 1 
SELECT NomProd
FROM Produit
WHERE NOT EXISTS (
    SELECT RefProd
    FROM DetailCommande
    WHERE DetailCommande.RefProd = Produit.RefProd);

# 2
SELECT Societe
FROM Fournisseur
WHERE EXISTS (
    SELECT NomProd
    FROM Produit
    WHERE Produit.NoFour = Fournisseur.NoFour
    AND EXISTS (
        SELECT RefProd
        FROM DetailCommande
        WHERE DetailCommande.RefProd = Produit.RefProd
        AND EXISTS (
            SELECT NoCom, PaysLiv
            FROM Commande
            WHERE Commande.NoCom = DetailCommande.NoCom
            AND PaysLiv = 'France'
        )
    )
);


-- Liste des fournisseurs qui ne proposent que des boissons (drinks)
# 3 
DESC Fournisseur;
DESC Produit;

SELECT Societe
FROM Fournisseur
WHERE EXISTS (   
    SELECT NoFour
    FROM Produit
    WHERE Produit.NoFour = Fournisseur.NoFour
    AND EXISTS (
        SELECT CodeCateg
        FROM Categorie
        WHERE  Categorie.CodeCateg = Produit.CodeCateg
        AND NomCateg = 'drinks'
        )
    );

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# VI- Opérations Ensemblistes
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# VI.1- Union
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Lister les employés (nom et prénom) étant"Representative"ou 
-- étant basé auRoyaume-Uni UK
# 1
SELECT Nom, Prenom, Fonction, Pays
FROM Employe
WHERE Fonction LIKE '%Representative%'
UNION 
SELECT  Nom, Prenom, Fonction, Pays
FROM Employe
WHERE Pays Like 'UK';

-- Lister les clients (société et pays) ayant commandés via un 
-- employé situé à Londres ("London"pour rappel) ou ayant été 
-- livré par"Speedy Express"
# 2
SELECT Client.Societe, Client.Pays
FROM Client
    INNER JOIN Commande ON Client.CodeCli = Commande.CodeCli
    INNER JOIN Employe ON Commande.NoEmp = Employe.NoEmp
    WHERE Employe.Ville = 'London'
UNION
SELECT Client.Societe, Client.Pays
FROM Client
    INNER JOIN Commande ON Client.CodeCli = Commande.CodeCli
    INNER JOIN Messager ON Commande.NoMess = Messager.NoMess
    WHERE Messager.NomMess = "Speedy Express";

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# VI.2- Intersection
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1
SELECT Nom, Prenom, Fonction, Pays
FROM Employe
WHERE Fonction LIKE '%Representative%'
INTERSECT 
SELECT  Nom, Prenom, Fonction, Pays
FROM Employe
WHERE Pays Like 'UK';

# 2
SELECT Client.Societe, Client.Pays
FROM Client
    INNER JOIN Commande ON Client.CodeCli = Commande.CodeCli
    INNER JOIN Employe ON Commande.NoEmp = Employe.NoEmp
    WHERE Employe.Ville = 'Seattle'
INTERSECT
SELECT Client.Societe, Client.Pays
FROM Client
    INNER JOIN Commande ON Client.CodeCli = Commande.CodeCli
    INNER JOIN DetailCommande ON Commande.NoCom = DetailCommande.NoCom
    INNER JOIN Produit ON DetailCommande.RefProd = Produit.RefProd
    INNER JOIN Categorie ON Produit.CodeCateg = Categorie.CodeCateg
    WHERE Categorie.NomCateg = "Desserts";
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# VI.3- Différence
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 1
SELECT Nom, Prenom, Fonction, Pays
FROM Employe
WHERE Fonction LIKE '%Representative%'
EXCEPT  
SELECT  Nom, Prenom, Fonction, Pays
FROM Employe
WHERE Pays Like 'UK';
# 2
