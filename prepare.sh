#!/usr/bin/env bash

export NOW_YEAR="$(date +'%Y')"
export SITE_URL="https://pjoc.pub"

function gen_deploy_file() {
	echo 'cat <<END_OF_TEXT' >  mkdocs_temp.sh
	cat $1                 >> mkdocs_temp.sh
	echo 'END_OF_TEXT'       >> mkdocs_temp.sh
	bash mkdocs_temp.sh > "$2"
	rm mkdocs_temp.sh

	cat $2
}

gen_deploy_file mkdocs_tpl.yml mkdocs.yml
