# WP-Locker (Beta)

**WP-Locker**, stands for "WordPress Local Docker", is a Docker configuration to set up a localhost environment for WordPress site development. It is based on the [WP-Docklines](https://github.com/tfirdaus/wp-docklines) image thus it includes tools and utilities that are commonly required for WordPress development such as [PHPUnit](https://phpunit.de/), [PHPCS](https://github.com/squizlabs/PHP_CodeSniffer), and [WordPress Coding Standards](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards).

## Requirements

To get "WP-Locker" up and running, you'll need to the following installed on your computer:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Git](https://git-scm.com/)

Follow the instruction below to get it up and running.

## Getting Started

Clone this repository; this following command will clone it to a new directory named `wp-locker` and change the directory to it.

```
git clone https://github.com/tfirdaus/wp-locker.git && cd wp-locker
```

Run the following command to initialize the localhost; building the containers up, installing WordPress Core with the default configuration in the `.env` file, installing the plugins from [WordPress.org repository](https://wordpress.org/plugins/) as well as the specified [Github](https://github.com/) or [Bitbucket](https://bitbucket.org/) repositories.

```
bin/init
```

The site should now be available at `http://localhost:8082`.

> **NOTE**: Change the URL port number accordingly following the `WORDPRESS_PORT` or the `WORDPRESS_PORT_HTTPS`, if you're aiming to load the site with HTTPS, variable in the `.env`.

## Importing and Exporting Database

If you'd like to import a database, put it inside the `dump` directory in `wp-locker` directory. Then run the following command; replace the `{{ database-name }}` with the SQL filename given.

```
bin/mysql-import dump/{{ database-name }}.sql
```

Run the following command to export the WordPress database. The file will be available inside the `dump` directory.

> **NOTE**: Replace the `{{ database-name }}` with the filename given. This process may take a while (perhaps, some minutes to almost an hour) to complete. However, If the process is hanging or unreasonably too long, you might be better to terminate the operation and import the database through an app like [Sequel Pro](https://github.com/tfirdaus/wp-locker/wiki/Using-Sequel-Pro) or [Navicat for Windows](https://www.navicat.com/en/products).

```
bin/mysql-export
```

## Stopping Containers

If you've done with the development, run the following command to stop containers and removes containers, networks, volumes, and images created by the `bin/up -d` command.

```
bin/down
```

To turn the container back up, simply run:

```
bin/up -d
```

You can browse the site again at `http://localhost:8082`.
