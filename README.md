[![PHP 8.2](https://img.shields.io/badge/php-8.2-%23777BB4?style=for-the-badge&logo=php&logoColor=black">)](https://www.php.net/releases/8_2_0.php)
[![MariaDB 11.1.3](https://img.shields.io/badge/MariaDB-11.1.3-003545?style=for-the-badge&logo=mariadb&logoColor=white)](https://mariadb.com/kb/en/mariadb-11-1-3-release-notes/)
[![Nginx 1.24-alpine](https://img.shields.io/badge/nginx-1.24-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)](https://nginx.org/en/CHANGES-1.24)
[![Symfony 7.0](https://img.shields.io/badge/symfony-7.0-%23000000.svg?style=for-the-badge&logo=symfony&logoColor=white)](https://symfony.com/doc/7.0)
[![Yarn](https://img.shields.io/badge/yarn-%232C8EBB.svg?style=for-the-badge&logo=yarn&logoColor=white)](https://www.npmjs.com/package/yarn/v/1.22.5)

## SHURIK-SERVER [(DB - schema)](https://dbdiagram.io/d/shurik-server-6628c54803593b6b61d4933e)

***

### First start for development environment:

```angular2html
make first-start

make create_shared_network -  общая сеть для базы даных Symfony + Slim
```

***

### Regular development:

```angular2html
make init
```

***

### DOCTRINE - clear database:

```angular2html
make php-cli
bin/console doctrine:schema:drop --full-database --force
bin/console doctrine:migration:migrate
```

***

### PRODUCTION:

```angular2html
make create_env_file - переписать данные /project/.env.local на prod окружение
make prod-first-start
```

***

### Generate JWT

```angular2html
make files:
project/config/jwt/private.pem
project/config/jwt/private.pem

$ openssl genrsa -out project/config/jwt/private.pem 4096
$ openssl rsa -pubout -in project/config/jwt/private.pem -out project/config/jwt/public.pem

### .env.local ###
JWT_SECRET_KEY=%kernel.project_dir%/config/jwt/private.pem
JWT_PUBLIC_KEY=%kernel.project_dir%/config/jwt/public.pem
JWT_PASSPHRASE=your-phrase
```

### Unit tests (.env.test)

```
DATABASE_USER=root
DATABASE_PASSWORD=root
DATABASE_NAME=store_database

php bin/console --env=test doctrine:database:create
php bin/console --env=test doctrine:schema:create
```
