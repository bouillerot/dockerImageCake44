SHELL 			:= /bin/bash # set shell based on host os, use /bin/zsh for mac
.DEFAULT_GOAL   := help

#
# define standard colors
#
ifneq (,$(findstring xterm,${TERM}))
	BLACK        := $(shell tput -Txterm setaf 0)
	RED          := $(shell tput -Txterm setaf 1)
	GREEN        := $(shell tput -Txterm setaf 2)
	YELLOW       := $(shell tput -Txterm setaf 3)
	LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
	PURPLE       := $(shell tput -Txterm setaf 5)
	BLUE         := $(shell tput -Txterm setaf 6)
	WHITE        := $(shell tput -Txterm setaf 7)
	RESET        := $(shell tput -Txterm sgr0)
else
	BLACK        := ""
	RED          := ""
	GREEN        := ""
	YELLOW       := ""
	LIGHTPURPLE  := ""
	PURPLE       := ""
	BLUE         := ""
	WHITE        := ""
	RESET        := ""
endif

#
# vars
#
DOCKER_COMPOSE  := "docker-compose.yml"
PHP             := $(shell docker-compose  ps -q php)
WEB             := $(shell docker-compose  ps -q web)
DB              := $(shell docker-compose  ps -q db)
IDU             := $(shell id -u)
UNAME           := $(shell uname -s)
TAGDATE         := $(shell date +%Y%m%d%H%M%S)
PHP_DEV_PATH	:= ".docker/php/development"

#
# unicode icons
#
CAKEPHP_ICO     := ' \U1F370 '
DOCKER_ICO      := ' \U1F40B '
SHELL_ICO       := ' \U1F41A '
MYSQL_ICO       := ' \U1F42C '
XDEBUG_ICO      := ' \U1F41E '
CANCEL_ICO      := ' \U1F515 '
KUBE_ICO        := ' \U2699 '
COMP_ICO        := ' \U1F3B5 '

#
# titles and separators
#
S               := \U203A
E               := $(RESET)\n
CMD             := \n   $(PURPLE)
GOOD            := $(GREEN)
INFO            := $(BLUE)
WARN            := $(YELLOW)

#
# cmds
#
DC_START        := docker-compose start
DC_STOP         := docker-compose stop
DC_UP           := docker-compose up
DC_DOWN         := docker-compose down
PHP_SH          := docker exec -it --user cakephp $(PHP) sh
DB_SH           := docker exec -it $(DB) sh
MYSQL_SH        := mysql -u root -h 0.0.0.0 -p --port 3307
WEB_SH          := docker exec -it $(WEB) sh
COMP_INSTALL    := docker exec $(PHP) composer install --no-interaction --no-plugins --no-scripts --prefer-dist
COMP_TEST       := docker exec $(PHP) composer test
COMP_CHECK      := docker exec $(PHP) composer check

#
# help
#
help:
	@clear
	@printf "\n"
	@printf $(CAKEPHP_ICO) && printf "$(RED) CakePHP Docker (infoGestion) $(S)"
	@printf "$(LIGHTPURPLE) https://github.com/bouillerot/dockerImageCake44 $(E)\n"
	@printf " commande \t\t description $(E)"
	@printf " -------- \t\t ----------- $(E)"
	@printf "$(INFO) make init $(RESET)\t\t construit et monte tous les conteneurs $(E)"
	@printf "$(INFO) make init.nocache $(RESET)\t idem sans le cache $(E)"
	@printf "\n"
	@printf "$(INFO) make start $(RESET)\t\t démarre les conteneurs $(E)"
	@printf "$(INFO) make stop $(RESET)\t\t stoppe les conteneurs $(E)"
	@printf "$(INFO) make up $(RESET)\t\t Monte les conteneurs $(E)"
	@printf "$(INFO) make down $(RESET)\t\t stoppe / retire les conteneurs, réseaux et volumes $(E)"
	@printf "$(INFO) make restart $(RESET)\t\t redémarre les conteneurs $(E)"
	@printf "$(INFO) make php.restart $(RESET)\t Redémarre le conteneur PHP $(E)"
	@printf "$(INFO) make web.restart $(RESET)\t Redémarre le conteneur WEB $(E)"
	@printf "\n"
	@printf "$(INFO) make php.sh $(RESET)\t\t CLI du conteneur php pour effectuer toute commade CLI style bin/cake bake ... ou migrations $(E)"
	@printf "$(INFO) make db.sh $(RESET)\t\t CLI du conteneur db $(E)"
	@printf "$(INFO) make web.sh $(RESET)\t\t CLI du conteneur web $(E)"
	@printf "$(INFO) make db.mysql $(RESET)\t\t console mysql $(E)"
	@printf "\n"
	@printf "$(INFO) make xdebug.on $(RESET)\t active xdebug $(E)"
	@printf "$(INFO) make xdebug.off $(RESET)\t désactive xdebug $(E)"
	@printf "$(INFO) make composer.install $(RESET)\t installe les dépendances via composer $(E)"
	@printf "$(INFO) make composer.test $(RESET)\t run phpunit test suite $(E)"
	@printf "$(INFO) make composer.check $(RESET)\t run phpunit and static analysis $(E)"
	@printf "\n"

#
# install command
#
init: do.copy
	@printf $(DOCKER_ICO) && printf "$(GOOD)running docker build and up $(E)"
	@mkdir -p app && touch app/.gitkeep
	@docker-compose build --build-arg UID=$(IDU) --build-arg ENV=dev --build-arg HOST_OS=$(UNAME)
	@$(DC_UP)
init.nocache: do.copy
	@printf $(DOCKER_ICO) && printf "$(GOOD)running docker build --no-cache and up $(E)"
	@mkdir -p app && touch app/.gitkeep
	@docker-compose build --build-arg UID=$(IDU) --build-arg ENV=dev --no-cache --build-arg HOST_OS=$(UNAME)
	@$(DC_UP)

#
# docker & docker-compose commands
#
start: do.copy
	@printf $(DOCKER_ICO) && printf "$(GOOD)start $(S) $(CMD) $(DC_START) $(E)"
	@$(DC_START)
stop:
	@printf $(DOCKER_ICO) && printf "$(WARN)stop $(S) $(CMD) $(DC_STOP) $(E)"
	@$(DC_STOP)
up: do.copy
	@printf $(DOCKER_ICO) && printf "$(GOOD)up $(S) $(CMD) $(DC_UP) -d $(E)"
	@$(DC_UP) -d
down:
	@printf $(DOCKER_ICO) && printf "$(WARN)down $(S) $(CMD) $(DC_DOWN) $(E)"
	@$(DC_DOWN)
restart: stop
	@printf $(DOCKER_ICO) && printf "$(GOOD)start $(S) $(CMD) $(DC_START) $(E)"
	@$(DC_START)
php.restart:
	@printf $(DOCKER_ICO) && printf "$(GOOD)restart $(S) php $(CMD) $(DC_STOP) php $(CMD) $(DC_START) php $(E)"
	@$(DC_STOP) php
	@cp .docker/php.env.development .docker/php.env
	@$(DC_START) php
web.restart:
	@printf $(DOCKER_ICO) && printf "$(GOOD)restart $(S) php $(CMD) $(DC_STOP) php $(CMD) $(DC_START) php $(E)"
	@$(DC_STOP) web
# @cp .docker/php.env.development .docker/php.env
	@$(DC_START) web

#
# container shell commands
#
php.sh:
	@printf $(SHELL_ICO) && printf "$(INFO)php $(S) $(CMD) $(PHP_SH) $(E)"
	@$(PHP_SH)
db.sh:
	@printf $(SHELL_ICO) && printf "$(INFO)db $(S) $(CMD) $(DB_SH) $(E)"
	@$(DB_SH)
db.mysql:
	@printf $(MYSQL_ICO) && printf "$(INFO)mysql $(S) $(CMD) $(MYSQL_SH) $(E)"
	@$(MYSQL_SH)
web.sh:
	@printf $(SHELL_ICO) && printf "$(INFO)web $(S) $(CMD) $(WEB_SH) $(E)"
	@$(WEB_SH)

#
# xdebug
#
xdebug.on:
	@printf $(XDEBUG_ICO) && printf "$(INFO)start xdebug $(S)"
	@docker container stop $(PHP) > /dev/null
	@sed -i '/xdebug.mode/c\xdebug.mode=coverage,debug' $(PHP_DEV_PATH)/conf.d/20-overrides.ini
	@docker container start $(PHP) > /dev/null
	@printf "$(GOOD) xdebug on $(E)"
xdebug.off:
	@printf $(XDEBUG_ICO) && printf "$(INFO)stop xdebug $(S)"
	@docker container stop $(PHP) > /dev/null
	@sed -i '/xdebug.mode/c\xdebug.mode=off' $(PHP_DEV_PATH)/conf.d/20-overrides.ini
	@docker container start $(PHP) > /dev/null
	@printf "$(WARN) xdebug off $(E)"

#
# composer commands
#
composer.install:
	@printf $(COMP_ICO) && printf "$(INFO)installing $(S) $(CMD) $(COMP_INSTALL) $(E)"
	@$(COMP_INSTALL)
	@docker exec $(PHP) composer dump-autoload
composer.test:
	@printf $(COMP_ICO) && printf "$(INFO)testing $(S) $(CMD) $(COMP_TEST) $(E)"
	@$(COMP_TEST)
composer.check:
	@printf $(COMP_ICO) && printf "$(INFO)checking $(S) $(CMD) $(COMP_CHECK) $(E)"
	@$(COMP_CHECK)

#
# internal
#
do.copy:
	@cp $(PHP_DEV_PATH)/conf.d/20-overrides.ini.development $(PHP_DEV_PATH)/conf.d/20-overrides.ini
