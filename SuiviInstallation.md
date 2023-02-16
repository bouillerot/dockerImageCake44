# Suivi installation image CakePhP conteneurisée

## Installation de l'image depuis le dépôt

- Cloner l'image.
- Renommer le répertoire dépôt selon la nouvelle application.
- Changer de répertoire
- Supprimer le répertoire app
- Supprimer le répertoire .git
- Lancer git init
- Pousser le dépôt existant depuis la ligne de commande

```bash
~/Documents/www$ git clone https://github.com/bouillerot/dockerImageCake44
~/Documents/www$ mv dockerImageCake44/ Dae2Cake44
~/Documents/www$ cd Dae2Cake44
~/Documents/www/Dae2Cake44$ rm -rf app
~/Documents/www/Dae2Cake44$ rm -rf .git
~/Documents/www/Dae2Cake44$ git init
~/Documents/www/Dae2Cake44$ git add .
~/Documents/www/Dae2Cake44$ git commit -m first commit
~/Documents/www/Dae2Cake44$ git remote add origin https://github.com/bouillerot/Dae2Cake44.git
~/Documents/www/Dae2Cake44$ git branch -M main
~/Documents/www/Dae2Cake44$ git push -u origin main
```

## Création de l'image CakePhp

```bash
~/Documents/www/Dae2Cake44$ make init
```
Relire de Readme.md pour épousseter quelques fichiers si nécessaire.

### Vérifier de suite le fonctionnement

- sur un navigateur avec l'url [http://localhost:8080](http://localhost:8080)

### Note Commande Make php.sh

- Toute commande "bake", "migration", etc. devra être exécutée via la ligne de commande du conteneur "php".





