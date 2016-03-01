EDITOR ?= vim
DEV_USER_ID=$(shell id -u)

all: build up

build:
	DEV_USER_ID=${DEV_USER_ID} docker-compose build

up:
	DEV_USER_ID=${DEV_USER_ID} docker-compose up

rm:
	docker-compose rm

clone:
	git clone git@github.com:magento/magento2.git

setup:
	@if [ ! -f "data/.composer/auth.json" ]; then \
	  cp template/composer-auth.json data/.composer/auth.json; \
	fi
	${EDITOR} data/.composer/auth.json

composer-install:
	docker exec -it dockermagento2_app_1 bash /opt/script/composer.sh install

composer-update:
	docker exec -it dockermagento2_app_1 bash /opt/script/composer.sh update

magento-install: composer-install
	docker exec -it dockermagento2_app_1 bash /opt/script/install.sh
