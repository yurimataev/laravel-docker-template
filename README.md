# Laravel Docker Test

Laravel development environment based on PHP-FPM, Nginx and MySQL, running out of Docker containers. This was done as practice in using `docker-compose` and setting up a CI/CD pipeline; use something like [Laradock](http://laradock.io/) for actual development.

## Setup

After cloning this repo, set up shop in the `app` folder using:

    docker run --rm -v $(pwd):/app composer create-project laravel/laravel app

Start everything with:

    docker-compose up -d

Execute artisan commands using:

    docker-compose exec app php artisan [...]

You can tweak MySQL, Nginx and PHP settings in the settings files located in the respective directories.

## License

This code is made available under the [MIT license](https://opensource.org/licenses/MIT).
