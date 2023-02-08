# &#128011; Docker

Je me suis fortement inspiré de [cnizzardini/cakephp-docker](https://github.com/cnizzardini/cakephp-docker).
Bien entendu nous avons notre propre Dockerfile pour notre production.

## NGINX

Voir les configurations dans le répertoire [nginx](nginx).
Elles sont chargées en tant que volume docker-compose.

## MySQL

Les variables d'environnement sont chargées par docker-compose depuis [mysql.env.development](mysql.env.development).

## PHP

Voir le répertoire [php](php) pour les fichiers de configuration liés à PHP, `healthcheck` et `entrypoint`.

Le fichier [php/development/conf.d/20-overrides.ini.development](php/development/conf.d/20-overrides.ini.development) est utilisé comme configuration de base pour remplir le git ignoré [php/development/conf.d/20-overrides.ini](php/development/conf.d/20-overrides.ini).
Ce dernier est en fait chargé par PHP.
Cela permet d'activer et de désactiver facilement xdebug via le Makefile.

Les variables d'environnement sont chargées par docker-compose depuis [php.env.development](php.env.development).
