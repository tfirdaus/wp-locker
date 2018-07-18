# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2018-07-18

### Added

- Submodule [`tfirdaus/wp-shell-localhost`]: A new file, `exec.sh`, as an alias to run `docker-composer exec` CLI.

### Changed

- phpMyAdmin is now the WordPress container dependency. This will force Docker to bring the phpMyAdmin container up when we run docker-compose up only for the WordPress container.
- The `bin` is now a submodule of [tfirdaus/wp-shell-localhost](https://github.com/tfirdaus/wp-shell-localhost)
  - Use the `docker-compose exec` when checking `wp-config.php` is ready, since the container is already up and running.
  - The `init.sh` to `init-apache.sh` to be more specific, as we might have several init scripts in the future to handle different services.
  - The "WP-Locker" banner since we've now separated the Shell script into its own repository that might be shared with other projects.
  - The `run.sh` file. The file is now included in [tfirdaus/wp-shell-pipelines](https://github.com/tfirdaus/wp-shell-pipelines) repository.

### Fixed

- Some shellcheck violations

## [0.2.0] - 2018-07-08

### Removed

- Dependant on a `Dockerfile`. Configurations are now moved to `docker-compose.yml`.

### Changed

- Run the `wp` command as a user instead of root.
- Bump-up default MySQL to MySQL 5.6.

### Added

- `wp.local` as an alternative domain and regenerate the default SSL cert to include the domain.
- `init.sh` file to initialize Apache and SSL configuration.

### Fixed

- Working directory environment variable.
- Apache RUN and LOG directory variable.

## [0.1.1] - 2018-01-13

### Added

- Shell helper to reset user group and permission

### Fixed

- "Too many positional arguments", which may appear when title passed contains two words or wrapped within a quote. [wp-cli/issues#1928](https://github.com/wp-cli/wp-cli/issues/1928)

## [0.1.0] - 2018-01-02

### Added

- SSL & HTTP Support
- A Shell helper to start the container and install WordPress
- A Shell helper to remove the container and the WordPress installation
- A file, `wp-locker-php.ini` to define custom PHP configurations
- A file, `wp-config-sample.php`, to define WordPress configurations upon initialization
- A file, `wp-locker.conf`, to define custom Apache configurations
- Ability to define plugins and theme to install from WordPress.org
- Ability to define plugins and theme to install from a remote Github, Bitbucket, and Gitlab

### Changed

- Wrap the PMA port withing a quote as suggested in [https://docs.docker.com/compose/compose-file/#ports](https://docs.docker.com/compose/compose-file/#ports)
- (Beta) status from the README

[Unreleased]: https://github.com/tfirdaus/wp-locker/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/tfirdaus/wp-locker/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/tfirdaus/wp-locker/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/tfirdaus/wp-locker/compare/v0.1.0...v0.1.1
