#!/bin/bash

contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}

# An alias command to run "docker-compose exec".
# Run a command in a running container as the www-data user.
dexec() {
	read -r -a DOCKER_SERVICES <<< "$(docker-compose config --services)"

	if [[ ! -z "$1" ]] && [[ $(contains "${DOCKER_SERVICES[@]}" "$1") == "y" ]]; then
		docker-compose exec -u www-data "$1" "${@:2}"
	else
		docker-compose exec -u www-data wordpress "$@"
	fi
}

ssh() {
	DOCKER_SERVICE=wordpress
	if [[ ! -z "$1" ]]; then
		DOCKER_SERVICE=$1
	fi
	docker-compose exec -u www-data "${DOCKER_SERVICE}" sh
}

ssh_root() {
	DOCKER_SERVICE=wordpress
	if [[ ! -z "$1" ]]; then
		DOCKER_SERVICE=$1
	fi
	docker-compose exec "${DOCKER_SERVICE}" sh
}

install_wp() {

	if [[ "$1" = "plugin" ]] || [[ "$1" = "theme" ]]; then
		local PLUGINS_INSTALLED=()
		local THEME_INSTALLED=""

		IFS=',' read -ra WP_REPOS <<< "$2"
		for WP_REPO in "${WP_REPOS[@]}"; do
			if ! dexec wp "$1" is-installed "$WP_REPO" && [[ "$1" = "plugin" ]]; then
				PLUGINS_INSTALLED+=("$WP_REPO")
			elif [[ "$1" = "plugin" ]]; then
				echo "⚠️ '${WP_REPO}' plugin already installed."
			fi

			if ! dexec wp "$1" is-installed "$WP_REPO" && [[ "$1" = "theme" ]] && [[ -z $THEME_INSTALLED ]]; then
				THEME_INSTALLED=$WP_REPO
			elif [[ "$1" = "theme" ]]; then
				echo "⚠️ '${WP_REPO}' theme already installed."
			fi
		done

		if [[ ${PLUGINS_INSTALLED[*]} ]]; then
			echo -e "\\n🚥 Installing WordPress plugins..."
			dexec wp plugin install "${PLUGINS_INSTALLED[@]}" --activate --allow-root
		fi

        if [[ "$1" = "theme" ]] && [[ ! -z $THEME_INSTALLED ]]; then
            echo -e "\\n🚥 Installing a WordPress theme..."
			dexec wp theme install "$THEME_INSTALLED" --activate --allow-root
		fi
	else
		echo "⛔️ Usage: $0 <plugin|theme> <list-of-plugins|list-of-themes>"
	fi
}

install_git_repo() {
	local GIT_REPOS=$1
	local REPO_DIR=""
	local REPO_BASEURL=""

	for i in "${@:2}"; do
		case $i in
			--source=*)
			if [[ ${i#*=} = "bitbucket" ]]; then
				REPO_BASEURL=https://bitbucket.org/
			fi
            if [[ ${i#*=} = "gitlab" ]]; then
				REPO_BASEURL=https://gitlab.com/
			fi
			shift;;
			--dest=*)
				local REPO_DEST=${i#*=}
			shift;;
		esac
	done

	IFS=',' read -ra repositories <<< "$GIT_REPOS"
	for repo in "${repositories[@]}"; do
		REPO_DIR=$(echo "${repo##*/}" | cut -d':' -f2)
		dexec mkdir -p "${REPO_DEST:-wp-content}/${REPO_DIR:-}" # Ensure the directory is there.
		if [[ "$(dexec ls -A "${REPO_DEST:-wp-content}/${REPO_DIR:-}" 2>/dev/null)" ]]; then
			echo "⚠️ The '${REPO_DEST:-wp-content}/${REPO_DIR:-}' directory is not empty; '${repo%:*}' repository might has been cloned."
		else
			echo "↙️ Cloning '${repo%:*}'..."
			dexec bash -c "cd ${REPO_DEST:-wp-content} && \
			git clone --quiet --progress ${REPO_BASEURL:-https://github.com/}${repo%:*}.git ${REPO_DIR:-}"
		fi
	done
}

replace_urls() {
	regex='(http|https)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
	if [[ $1 =~ $regex ]]; then
		SITEURL=$(dexec wp option get siteurl)
		SITEURL_ESC=$(echo -e "$SITEURL" | sed -e 's/[[:space:]]*$//' -e "s/'//g")
	else
		echo -e "\\n⛔️ URL is not supplied or invalid."
	fi

	if [[ ! -z "$SITEURL_ESC" ]] && [[ "$1" != "$SITEURL_ESC" ]]; then
		echo -e "\\n🔄 Replacing the site URLs in the database to $1."
		dexec wp search-replace "$SITEURL_ESC" "$1" --precise --recurse-objects --all-tables --skip-themes --skip-plugins --skip-packages
		echo "Your site URL: $1"
	else
		WP_SITE_URL="http://${WP_SITE_DOMAIN}:${WP_PUBLISHED_PORT}"
		echo "Your site URL: ${WP_SITE_URL}${WP_SITE_SUBDIR}"
	fi
}
