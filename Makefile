all: build up

build:
	docker-compose build

up:
	docker-compose up

rm:
	docker-compose rm

clone:
	git clone git@github.com:magento/magento2.git

setup:
	cp template/composer-auth.json data/.composer/auth.json
	vim data/.composer/auth.json

composer-install:
	docker exec -it dockermagento2_app_1 bash /opt/script/composer.sh install

composer-update:
	docker exec -it dockermagento2_app_1 bash /opt/script/composer.sh update

magento-install: composer-install
	docker exec -it dockermagento2_app_1 bash /opt/script/install.sh
