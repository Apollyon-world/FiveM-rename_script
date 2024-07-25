# FiveM-rename_script 📇

Un script FiveM qui vous permet de vous rename en jeu en tant qu'Admin


## Usage 📲

```
/rename [ID] [Prénom] [Nom]
```

## Config ⚙️

Vous voulez adaptez le script à votre serveur ? Pas de problème !

### SQL Command 📝
Le script utilise oxmysql pour communiquer avec la base de donnée, il vous suffit donc de changer la partie SQL

Exemples : 

```SQL
UPDATE users SET firstname = ?, lastname = ? WHERE identifier = ? 
```

```SQL
UPDATE joueurs SET prenom = ?, nom = ? WHERE identifiants = ? 
```

```SQL
UPDATE users SET [CUSTOM-FIRSTNAME] = ?, [CUSTOM-LASTNAME] = ? WHERE identifier = ? 
```

### API 🔗

**Frameworks :** *ESX & QBCORE*

**Dépendances :** *oxmysql*

## Sécuritée 🛡

Le script est sécurisée car il est **server-side** c'est à dire qu'il n'y a que le serveur qui y a accès.
