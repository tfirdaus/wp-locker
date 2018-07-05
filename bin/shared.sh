#!/bin/bash

run() {
    docker-compose exec -u www-data wordpress "$@"
}

run_root() {
	docker-compose exec wordpress "$@"
}

ssh() {
	docker-compose exec -u www-data wordpress sh
}

ssh_root() {
	docker-compose exec wordpress sh
}

banner() {
	if [[ ${WP_LOCKER_BANNER:-1} -ge 1 ]]; then
	cat <<-'EOF'

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
	#    _       ______        __    ____  ________ __ __________   #
	#   | |     / / __ \      / /   / __ \/ ____/ //_// ____/ __ \  #
	#   | | /| / / /_/ /_____/ /   / / / / /   / ,<  / __/ / /_/ /  #
	#   | |/ |/ / ____/_____/ /___/ /_/ / /___/ /| |/ /___/ _, _/   #
	#   |__/|__/_/         /_____/\____/\____/_/ |_/_____/_/ |_|    #
	#                                                               #
	#      Repository: https://github.com/tfirdaus/wp-locker        #
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	EOF
	fi
}

install_wp() {

	if [[ "$1" = "plugin" ]] || [[ "$1" = "theme" ]]; then
		local PLUGINS_INSTALLED=()
		local THEME_INSTALLED=""

		IFS=',' read -ra WP_REPOS <<< "$2"
		for WP_REPO in "${WP_REPOS[@]}"; do
			if ! run wp $1 is-installed $WP_REPO && [[ "$1" = "plugin" ]]; then
				PLUGINS_INSTALLED+=("$WP_REPO")
			elif [[ "$1" = "plugin" ]]; then
				echo "⚠️ '${WP_REPO}' plugin already installed."
			fi

			if ! run wp $1 is-installed $WP_REPO && [[ "$1" = "theme" ]] && [[ -z $THEME_INSTALLED ]]; then
				THEME_INSTALLED=$WP_REPO
			elif [[ "$1" = "theme" ]]; then
				echo "⚠️ '${WP_REPO}' theme already installed."
			fi
		done

		if [[ ${PLUGINS_INSTALLED[*]} ]]; then
			echo "🚥 Installing WordPress plugins..."
			run wp plugin install "${PLUGINS_INSTALLED[@]}" --activate --allow-root
		fi

        if [[ "$1" = "theme" ]] && [[ ! -z $THEME_INSTALLED ]]; then
            echo "🚥 Installing a WordPress theme..."
			run wp theme install $THEME_INSTALLED --activate --allow-root
		fi
	else
		echo "⛔️ Usage: $0 <plugin|theme> <list-of-plugins|list-of-themes>"
	fi

	run wp plugin update --all --skip-plugins --skip-themes
	run wp theme update --all --skip-plugins --skip-themes
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
		REPO_DIR=$(echo ${repo##*/} | cut -d':' -f2)
		run mkdir -p ${REPO_DEST:-wp-content}/${REPO_DIR:-} # Ensure the directory is there.
		if [[ "$(run ls -A ${REPO_DEST:-wp-content}/${REPO_DIR:-} 2>/dev/null)" ]]; then
			echo "⚠️ The '${REPO_DEST:-wp-content}/${REPO_DIR:-}' directory is not empty; '${repo%:*}' repository might has been cloned."
		else
			echo "↙️ Cloning '${repo%:*}'..."
			run bash -c "cd ${REPO_DEST:-wp-content} && \
			git clone --quiet --progress ${REPO_BASEURL:-https://github.com/}${repo%:*}.git ${REPO_DIR:-}"
		fi
	done
}

replace_urls() {
	regex='(http|https)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
	if [[ $1 =~ $regex ]]; then
		SITEURL=$(run wp option get siteurl)
		SITEURL_ESC=$(echo -e "$SITEURL" | sed -e 's/[[:space:]]*$//' -e "s/'//g")
	else
		echo "⛔️ URL is not supplied or invalid."
	fi
	if [[ ! -z "$SITEURL_ESC" ]] && [[ "$1" != "$SITEURL_ESC" ]]; then
		echo "🔄 Replacing the site URLs in the database to $1."
		run wp search-replace "$SITEURL_ESC" "$1" --precise --recurse-objects --all-tables --skip-themes --skip-plugins
	fi

	echo "Your site URL: $1"
}

reset_permission() {
	echo "🚥 Resetting owner & permission..."
	run_root bash -c "chown www-data:www-data -R ./*"
}