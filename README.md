# &#127856; CakePHP Docker

[![Build](https://github.com/bouillerot/dockerImageCake44/workflows/Build/badge.svg?branch=master)](https://github.com/bouillerot/dockerImageCake44/actions)
[![CakePHP](https://img.shields.io/badge/cakephp-4-red?logo=cakephp)](https://book.cakephp.org/4/en/index.html)
[![Docker](https://img.shields.io/badge/docker-ffffff.svg?logo=docker)](.docker)
[![Kubernetes](https://img.shields.io/badge/kubernetes-D3D3D3.svg?logo=kubernetes)](.kube)
[![PHP](https://img.shields.io/badge/php-8.1-8892BF.svg?logo=php)](https://hub.docker.com/_/php)
[![NGINX](https://img.shields.io/badge/nginx-1.19-009639.svg?logo=nginx)](https://hub.docker.com/_/nginx)
[![MySQL](https://img.shields.io/badge/mysql-8-00758F.svg?logo=mysql)](https://hub.docker.com/_/mysql)

Un modèle [cakephp/app](https://github.com/cakephp/app)
pour Docker Compose et Kubernetes.
Pour information voir aussi :
- [CakePHP Galley](https://gitlab.com/amayer5125/galley) similaire à Laravel Sail
- [DevilBox](https://devilbox.readthedocs.io/en/latest/examples/setup-cakephp.html).

#### Dépendances :

- [Docker 20](https://docs.docker.com/engine/release-notes/) or higher
- Make

| Service                | Host:Port      | Docker Host | Image                                                                                        |
|------------------------|----------------|-------------|----------------------------------------------------------------------------------------------|
| PHP8.1-FPM w/ Xdebug 3 | -              | php         | [bouillerot/dockerImageCake44](https://github.com/bouillerot/dockerImageCake44) |
| NGINX 1.19             | localhost:8080 | web         | [nginx:1.19-alpine](https://hub.docker.com/_/nginx)                                          |
| MySQL 8                | localhost:3607 | db          | [library/mysql:8](https://hub.docker.com/_/mysql)                                            |


- [Installation](#installation)
- [MacOS Notes](#mac-notes)
- [Usage](#usage)
  - [PHP](#php)
  - [MySQL](#mysql)
  - [NGINX](#nginx)
  - [Xdebug](#xdebug)
- [Reinstall](#reinstall)

## Installation

Fourchez et clonez ce référentiel, puis exécutez:

```console
make init
```

C'est tout ! Maintenant retirez simplement `app/*` de [.gitignore](.gitignore). Vous pouvez également supprimer
[.assets](.assets) et ajuster les valeurs par défaut [.github](.github), [.docker](.docker) et [.kube](.kube).

> Note : `make init` et `make init.nocache` interagissent avec l'utilisateur, mais pas `make start` et `make up`.

## Mac Notes

1. Changez votre  `SHELL` dans le Makefile en `/bin/zsh`. Cela améliore divers affichages tels les emoji's.

3. Mac est livré avec une ancienne version de `sed` donc installez `gnu-sed` pour certaines actions dans le Makefile :

```console
brew install gnu-sed
```

Puis remplacez `sed` par `gsed` dans le Makefile.

## Usage

Après l'installation, naviguez vers [http://localhost:8080](http://localhost:8080) pour visualiser la page de bienvenue de CakePHP.

Un [Makefile](Makefile) est fourni avec quelques commandes facultatives pour votre commodité.
Veuillez consulter le Makefile car ces commandes ne sont pas des alias exacts des commandes docker-compose.

| Make Command            | Description                                                                             |
|-------------------------|-----------------------------------------------------------------------------------------|
| `make`                  | Affiche toutes les commandes make                                                       |
| `make init`             | Exécute docker build, docker-compose up et copie les fichiers env                       |
| `make init.nocache`     | Identique à make.init mais construit avec --no-cache                                    |
| `make start`            | Démarre les services `docker-compose -f .docker/docker-compose.yml start`               |
| `make stop`             | Stoppe les services `docker-compose -f .docker/docker-compose.yml stop`                 |
| `make up`               | Crée et démarre les containers `docker-compose -f .docker/docker-compose.yml up -d`     |
| `make down`             | Démonte et supprime les containers `docker-compose -f .docker/docker-compose.yml down`  |
| `make restart`          | Redémarre les services `docker-compose -f .docker/docker-compose.yml restart`           |
| `make php.sh`           | Terminal PHP `docker exec -it --user cakephp <PHP_CONTAINER> sh`                        |
| `make php.restart`      | Redémarre le conteneur PHP                                                              |
| `make db.sh`            | Terminal DB `docker exec -it <DB_CONTAINER> sh`                                         |
| `make db.mysql`         | Terminal MySQL `mysql -u root -h 0.0.0.0 -p --port 3307`                                |
| `make web.sh`           | Terminal Web `docker exec -it <WEB_CONTAINER> sh`                                       |
| `make xdebug.on`        | Redémarre le conteneur PHP avec xdebug.mode activé                                      |
| `make xdebug.off`       | Redémarre le conteneur PHP avec xdebug.mode activé                                      |
| `make composer.install` | `docker exec <PHP_CONTAINER> composer install --no-interaction`                         |
| `make composer.test`    | `docker exec <PHP_CONTAINER> composer test`                                             |
| `make composer.check`   | `docker exec <PHP_CONTAINER> composer check`                                            |

### PHP

See [.docker/README.md](.docker/README.md) for details.

Shell:

```console
make php.sh
```

Helper commands:

```console
make composer.install
make composer.test
make composer.check
```

### MySQL

See [.docker/README.md](.docker/README.md) for details.

Shell:

```console
make db.sh
```

MySQL shell (requires mysql client on your localhost):

```console
make db.mysql
```

### NGINX

See [.docker/README.md](.docker/README.md) for details.

Shell:

```console
make web.sh
```

### Xdebug

Xdebug is disabled by default. To toggle:

```console
make xdebug.on
make xdebug.off
```

### PHPStorm + Xdebug

Xdebug 3's default port is `9003`.

Go to `File > Settings > Languages & Frameworks > PHP > Servers`

- Name: `localhost`
- Host: `localhost`
- Port: `8080`
- Debugger: `Xdebug`
- Use path mappings: `Enable`

Map your project's app directory to the absolute path on the docker container `/srv/app`

## Reinstall

To completely reinstall delete existing containers and images, then remove the `app/` directory and run `make init`
again.
