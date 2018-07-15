#!/bin/bash

# ======================================================================
# Initialize a project (installing plugins, dependencies, and WordPress)
# ======================================================================

# shellcheck source=bin/shared.sh
# shellcheck disable=SC1091
source "$(dirname "$0")/shared.sh"

while IFS= read -r line; do
	export "$(echo -e "$line" | sed -e 's/[[:space:]]*$//' -e "s/'//g")"
done < <(grep WP_ .env)

while IFS= read -r line; do
	export "$(echo -e "$line" | sed -e 's/[[:space:]]*$//' -e "s/'//g")"
done < <(grep PROJECTS_ .env)

INSTALL_PLUGINS=""
INSTALL_THEMES=""
WP_SITE_URL="http://${WP_SITE_DOMAIN}:${WP_PUBLISHED_PORT}"
for i in "$@"; do
	case $i in
		--wp-plugins)
	    INSTALL_PLUGINS=1
	    shift
	    ;;
		--wp-themes)
	    INSTALL_THEMES=1
	    shift
	    ;;
		--https)
	    WP_SITE_URL_HTTPS="https://${WP_SITE_DOMAIN}:${WP_PUBLISHED_PORT_HTTPS}"
	    shift
	    ;;
	esac
done

# Install WordPress Core
if ! dexec wp core is-installed &>/dev/null; then

	# ========================================================================================================================
	# NOTE: The command may throw an error even though we have added --skip-email parameter. But I guess we can just ignore it.
	# https://github.com/wp-cli/core-command/blob/f302ad901aa119136684610f91087c592503150b/features/core.feature#L349
	# It might also throw an error if the site have `mu-plugins` active.
	# ========================================================================================================================

	echo -e "\\n🚥 Installing WordPress Core..."

	# shellcheck disable=SC2086
	dexec wp core install \
		--skip-email \
		--title="${WP_SITE_TITLE:-WordPress}" \
		--url=${WP_SITE_URL_HTTPS:-$WP_SITE_URL} \
		--admin_user=${WP_ADMIN_USER:-admin} \
		--admin_password=${WP_ADMIN_PASSWORD:-password} \
		--admin_email=${WP_ADMIN_EMAIL:-admin@localhost.local}
else
	echo "⚠️ WordPress Core already installed."
fi

if [[ -n $INSTALL_PLUGINS ]] && [[ $INSTALL_PLUGINS -ge 1 ]]; then
	install_wp plugin "$WP_PLUGINS"
	install_git_repo "$PROJECTS_GITHUB_PLUGINS" --dest=wp-content/plugins
	install_git_repo "$PROJECTS_BITBUCKET_PLUGINS" --source=bitbucket --dest=wp-content/plugins
	install_git_repo "$PROJECTS_GITLAB_PLUGINS" --source=gitlab --dest=wp-content/plugins
fi

if [[ -n $INSTALL_THEMES ]] && [[ $INSTALL_THEMES -ge 1 ]]; then
	install_wp theme "$WP_THEMES"
	install_git_repo "$PROJECTS_GITHUB_THEMES" --dest=wp-content/themes
	install_git_repo "$PROJECTS_BITBUCKET_THEMES" --source=bitbucket --dest=wp-content/themes
	install_git_repo "$PROJECTS_GITLAB_THEMES" --source=gitlab --dest=wp-content/themes
fi

replace_urls "${WP_SITE_URL_HTTPS:-$WP_SITE_URL}${WP_SITE_SUBDIR}"
