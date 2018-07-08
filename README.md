# WP Locker with Apache

**WP Locker**, stands for "WordPress Local Docker", is a Docker configuration to set up an Apache localhost environment for WordPress site development. It is based on the [WP-Docklines](https://github.com/tfirdaus/wp-docklines) image. It includes tools and utilities that are commonly required in WordPress development such as [PHPUnit](https://phpunit.de/), [PHPCS](https://github.com/squizlabs/PHP_CodeSniffer), and [WordPress Coding Standards](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards).

## Why?

There are a number of Docker configurations for WordPress development. Yet, I found most of these images are stacked with things that are not needed in my projects, unsuitable for my workflow, or do not work with the CI service that I'm using. So eventually, I have to built my own and it's also become an opportunity for me to dig into Docker deeper.

## Requirements

To get "WP Locker" up and running, you'll need to the following installed on your computer:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

Follow the instruction below to get it up and running.

## Getting Started

Download or clone this repository.

```shell
git clone -b master https://github.com/tfirdaus/wp-locker.git && cd wp-locker
```

Theh above command will clone it to a new directory named `wp-locker` and change the directory to it.

Run the following command to start the localhost. It will build the containers up, install WordPress Core with the default configuration in the `.env` file, installing the plugins from [WordPress.org repository](https://wordpress.org/plugins/) as well as the specified [Github](https://github.com/) or [Bitbucket](https://bitbucket.org/) repositories.

```shell
bash bin/start.sh
```

The site should now be available at `http://localhost:8082` unless you've changed the `WORDPRESS_DOMAIN` or `WORDPRESS_PORT` value in the `.env` file. If you've done with the development, you can turn the localhost of by running the following command; it will stop the containers, the networks, the volumes, and the images that have been created.

```shell
bash bin/down.sh
```

To turn the container back up, simply run:

```shell
bash bin/up.sh -d
```

You can browse the site again at `http://wp.local:8082`, and be sure to check the **[Wiki page](https://github.com/tfirdaus/wp-locker/wiki)** for more usage and tutorials.

## Shell Helper Cheatsheet

**WP Locker** comes with a set of Shell helpers to perform some _tedious_ tasks. Here are some that you might need often:

| Command | Description |
| --- | --- |
| `bash bin/start.sh` | Starting the localhost with WordPress, the theme, and the plugins installed |
| `bash bin/start.sh --https` | Starting the localhost to load with HTTPS; also install WordPress, theme, and plugins if it's not done so |
| `bash bin/up.sh` | Build/rebuild the Docker image and spinning the localhost |
| `bash bin/up.sh -d` | Spinning up the localhost in the background |
| `bash bin/down.sh` | Shutting-down the container |
| `bash bin/destroy.sh` | Shutting-down the container and remove everything |

## Looking for an nginx flavour?

It's currently a WIP. So, stay tuned.
