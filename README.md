# WP-Locker with Apache (Beta)

**WP-Locker**, stands for "WordPress Local Docker", is a Docker configuration to set up an Apache localhost environment for WordPress site development. It is based on the [WP-Docklines](https://github.com/tfirdaus/wp-docklines) image. It includes tools and utilities that are commonly required in WordPress development such as [PHPUnit](https://phpunit.de/), [PHPCS](https://github.com/squizlabs/PHP_CodeSniffer), and [WordPress Coding Standards](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards).

## Requirements

To get "WP-Locker" up and running, you'll need to the following installed on your computer:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Git](https://git-scm.com/)

Follow the instruction below to get it up and running.

## Getting Started

Download or clone this repository. This following command will clone it to a new directory named `wp-locker` and change the directory to it.

```
git clone https://github.com/tfirdaus/wp-locker.git && cd wp-locker
```

Run the following command to start the localhost. It will build the containers up, install WordPress Core with the default configuration in the `.env` file, installing the plugins from [WordPress.org repository](https://wordpress.org/plugins/) as well as the specified [Github](https://github.com/) or [Bitbucket](https://bitbucket.org/) repositories.

```
bin/start
```

The site should now be available at `http://localhost:8082` unless you've changed the `WORDPRESS_DOMAIN` or `WORDPRESS_PORT` value in the `.env` file. If you've done with the development, you can turn the localhost of by running the following command; it will stop the containers, the networks, the volumes, and the images that have been created.

```
bin/down
```

To turn the container back up, simply run:

```
bin/up -d
```

You can browse the site again at `http://localhost:8082`, and be sure to check the [Wiki](https://github.com/tfirdaus/wp-locker/wiki) for more usage and tutorials.

## Looking for an nginx flavour?

It's currently a WIP. So, stay tuned.
