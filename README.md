# Laravel Docker Test

Laravel development environment based on PHP-FPM, Nginx and MySQL, running out of Docker containers. This was done as `docker-compose` practice, use something like [Laradock](http://laradock.io/) for actual development.

## Setup

After cloning this repo, get the Laravel source code from the official repo by running:

    git submodule init
    git submodule update

Start everything with:

    docker-compose up -d

Execute artisan commands using:

    docker-compose exec app php artisan [...]

You can tweak MySQL, Nginx and PHP settings in the settings files located in the respective directories.

## License

This code is made available under the [MIT license](https://opensource.org/licenses/MIT).
