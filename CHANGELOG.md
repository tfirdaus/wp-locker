# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## 0.1.0 - 2018-01-02
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

[Unreleased]: https://github.com/tfirdaus/wp-locker/compare/v0.1.1...HEAD
