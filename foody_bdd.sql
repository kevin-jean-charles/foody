
DROP DATABASE IF EXISTS foody; 
CREATE DATABASE foody;
USE foody;

CREATE TABLE Messager (
    NoMess INT NOT NULL AUTO_INCREMENT,
    NomMess VARCHAR(50),
    Tel VARCHAR(20),
    PRIMARY KEY (NoMess)
);

CREATE TABLE Categorie (
    CodeCateg INT NOT NULL AUTO_INCREMENT,
    NomCateg VARCHAR(15) NOT NULL,
    Descriptionn VARCHAR(255),
    PRIMARY KEY (CodeCateg)
);

CREATE TABLE Client (
    Codecli VARCHAR(5) NOT NULL,
    Societe VARCHAR(45) NOT NULL,
    Contact VARCHAR(45) NOT NULL,
    Fonction VARCHAR(45) NOT NULL,
    Adresse VARCHAR(45),
    Ville VARCHAR(25),
    Region VARCHAR(25),
    Codepostal VARCHAR(10),
    Pays VARCHAR(25),
    Tel VARCHAR(25),
    Fax VARCHAR(25),
    PRIMARY KEY (Codecli)
);

CREATE TABLE Fournisseur (
    NoFour INT NOT NULL AUTO_INCREMENT,
    Societe VARCHAR(45) NOT NULL,
    Contact VARCHAR(45) ,
    Fonction VARCHAR(45) ,
    Adresse VARCHAR(255) ,
    Ville VARCHAR(45),
    Region VARCHAR(45),
    CodePostal VARCHAR(10) ,
    Pays VARCHAR(45) ,
    Tel VARCHAR(20) ,
    Fax VARCHAR(20),
    PageAccueil MEDIUMTEXT,
    PRIMARY KEY (NoFour)
);


CREATE TABLE Employe (
    NoEmp INT NOT NULL AUTO_INCREMENT,
    Nom VARCHAR(50) NOT NULL,
    Prenom VARCHAR(50) NOT NULL,
    Fonction VARCHAR(50) ,
    TitreCourtoisie VARCHAR(50),
    DateNaissance DATETIME,
    DateEmbauche DATETIME,
    Adresse VARCHAR(60),
    Ville VARCHAR(50),
    Region VARCHAR(50),
    Codepostal VARCHAR(50),
    Pays VARCHAR(50) ,
    TelDom VARCHAR(20) ,
    Extension VARCHAR(50),
    RendCompteA INT, 
    PRIMARY KEY (NoEmp)
);

CREATE TABLE Commande (
    NoCom INT NOT NULL AUTO_INCREMENT,
    CodeCli VARCHAR(10) ,
    NoEmp INT,
    DateCom DATETIME ,
    ALivAvant DATETIME,
    DateEnv DATETIME,
    NoMess INT ,
    Portt DECIMAL(10,4) DEFAULT 0,
    Destinataire VARCHAR(50) ,
    AdrLiv VARCHAR(50) ,
    VilleLiv VARCHAR(50) ,
    RegionLiv VARCHAR(50),
    CodePostalLiv VARCHAR(20),
    PaysLiv VARCHAR(25) ,
    PRIMARY KEY (NoCom)
);



CREATE TABLE Produit (
    RefProd INT NOT NULL AUTO_INCREMENT,
    NomProd VARCHAR(50) NOT NULL,
    NoFour INT,
    CodeCateg INT,
    QteParUnit VARCHAR(20),
    PrixUnit DECIMAL(10,4) default 0,
    UnitesStock SMALLINT DEFAULT 0,
    UnitesCom SMALLINT DEFAULT 0,
    NiveauReap SMALLINT DEFAULT 0,
    Indisponible BIT NOT NULL default 0,
    PRIMARY KEY (RefProd)
);


CREATE TABLE DetailCommande (
    NoCom INT NOT NULL,
    RefProd INT NOT NULL,
    PrixUnit DECIMAL(10,4) NOT NULL DEFAULT 0,
    Qte INT NOT NULL DEFAULT 1,
    Remise Double NOT NULL DEFAULT 0,
    PRIMARY KEY (NoCom , RefProd)
);



#----------------------------

ALTER TABLE Commande
ADD FOREIGN KEY (CodeCli) REFERENCES Client(CodeCli);

ALTER TABLE Commande
ADD FOREIGN KEY (NoEmp) REFERENCES Employe(NoEmp);

ALTER TABLE Commande
ADD FOREIGN KEY (NoMess) REFERENCES Messager(NoMess);

#----------------------------

ALTER TABLE Employe
ADD FOREIGN KEY (RendCompteA) REFERENCES Employe(NoEmp);

#----------------------------

ALTER TABLE Produit
ADD FOREIGN KEY (NoFour) REFERENCES Fournisseur(NoFour);

ALTER TABLE Produit
ADD FOREIGN KEY (CodeCateg) REFERENCES Categorie(CodeCateg);

#----------------------------

ALTER TABLE DetailCommande
ADD FOREIGN KEY (NoCom) REFERENCES Commande(NoCom);


ALTER TABLE DetailCommande
ADD FOREIGN KEY (RefProd) REFERENCES Produit(RefProd);
