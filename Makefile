init: docker-down docker-pull docker-build docker-up
prod-init: prod-docker-down prod-docker-pull prod-docker-build prod-docker-up

first-start: create_env_file create_network init composer-install migration-migrate yarn
prod-first-start: create_network prod-init prod-composer-install prod-migration-migrate prod-yarn

prod-update: git-pull prod-composer-install prod-migration-migrate prod-yarn prod-yarn-build

git-pull:
	git pull

up: docker-up
down: docker-down
restart: down up

create_network:
	docker network create laravel-server

create_shared_network:
	docker network create --driver bridge laravel-network

gen-letsencrypt_keys:
	docker compose -f docker-compose-LE.yml --env-file ./project/.env.local up -d

docker-pull:
	docker-compose --env-file ./project/.env.local pull

docker-build:
	docker-compose --env-file ./project/.env.local build --pull

docker-up:
	docker-compose --env-file ./project/.env.local up -d

prod-docker-up:
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local up -d

docker-down:
	docker-compose --env-file ./project/.env.local down --remove-orphans

prod-docker-down:
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local down -v --remove-orphans

yarn-install:
	docker-compose --env-file ./project/.env.local run --rm node-cli yarn install

yarn-watch:
	docker-compose --env-file ./project/.env.local run --rm node-cli yarn watch

yarn-dev:
	docker-compose --env-file ./project/.env.local run --rm node-cli yarn dev

php-cli:
	docker-compose --env-file ./project/.env.local run --rm php-cli bash

yarn:
	cd project
	docker-compose --env-file ./project/.env.local run --rm node-cli yarn
	docker-compose --env-file ./project/.env.local run --rm node-cli yarn build

composer-install:
	docker-compose --env-file ./project/.env.local run --rm php-cli composer install

migration-migrate:
	docker-compose --env-file ./project/.env.local run --rm php-cli bin/console d:m:m --no-interaction
	docker-compose --env-file ./project/.env.local run --rm php-cli bin/console d:f:l --append
	docker-compose --env-file ./project/.env.local run --rm php-cli bin/console c:c

dev-update: yarn composer-install migration-migrate

image-docker-build:
	docker --log-level=debug build --pull --file=docker/production/nginx/Dockerfile --tag=ghcr.io/shurik-market-team/repository/ms_product_nginx:master docker
	docker --log-level=debug build --pull --file=docker/production/node-cli/Dockerfile --tag=ghcr.io/shurik-market-team/repository/ms_product_node-cli:master docker
	docker --log-level=debug build --pull --file=docker/production/php-cli/Dockerfile --tag=ghcr.io/shurik-market-team/repository/ms_product_php-cli:master docker
	docker --log-level=debug build --pull --file=docker/production/php-fpm/Dockerfile --tag=ghcr.io/shurik-market-team/repository/ms_product_php-fpm:master docker

# docker login ghcr.io/shurik-market-team
image-docker-push:
	docker push ghcr.io/shurik-market-team/repository/ms_product_nginx:master
	docker push ghcr.io/shurik-market-team/repository/ms_product_node-cli:master
	docker push ghcr.io/shurik-market-team/repository/ms_product_php-cli:master
	docker push ghcr.io/shurik-market-team/repository/ms_product_php-fpm:master

prod-start:
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local up -d

prod-yarn:
	cd project
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local run --rm node-cli yarn

prod-yarn-build:
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local run --rm node-cli yarn build

prod-composer-install:
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local run --rm php-cli composer install

prod-migration-migrate:
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local run --rm php-cli bin/console d:m:m --no-interaction
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local run --rm php-cli bin/console c:c

prod-php-cli:
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local run --rm php-cli bash

prod-docker-update: prod-docker-pull prod-docker-build

prod-docker-pull:
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local pull

prod-docker-build:
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local build --pull

prod-sync-server:
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local run --rm php-cli bin/console app:sync-server

prod-sanitize-cart:
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local run --rm php-cli bin/console app:sanitize-cart

prod-diginetica-search:
	docker-compose -f docker-compose-prod.yml --env-file ./project/.env.local run --rm php-cli bin/console app:diginetica-search

unit-test:
	docker-compose --env-file ./project/.env.local run --rm php-cli bin/phpunit

create_env_file:
	echo "###> symfony/framework-bundle ###" > ./project/.env.local
	echo "APP_NAME=shurik-server" >> ./project/.env.local
	echo "APP_ENV=prod" >> ./project/.env.local
	echo "APP_SECRET=gen_new_secret_for_app" >> ./project/.env.local
	echo "###< symfony/framework-bundle ###" >> ./project/.env.local
	echo "###> env for docker-compose-prod.yml ###" >> ./project/.env.local
	echo "DATABASE_USER=set_user_name" >> ./project/.env.local
	echo "DATABASE_PASSWORD=prod_set_database_password" >> ./project/.env.local
	echo "DATABASE_NAME=prod_set_database_name" >> ./project/.env.local
	echo "MARIADB_ROOT_PASSWORD=prod_set_root_password" >> ./project/.env.local
	echo "###< env for docker-compose-prod.yml ###" >> ./project/.env.local
	echo "###> for letsencrypt keys ###" >> ./project/.env.local
	echo "USER_EMAIL=info@shurik.market" >> ./project/.env.local
	echo "USER_DOMAIN=dev.shurik.market" >> ./project/.env.local
	echo "###< for letsencrypt keys ###" >> ./project/.env.local
	echo "###> 1C local server address" >> ./project/.env.local
	echo "SERVER_IP_1C=http://192.168.40.20/UT/hs/www.osm.ru/get/" >> ./project/.env.local
	echo "###< 1C local server address" >> ./project/.env.local
