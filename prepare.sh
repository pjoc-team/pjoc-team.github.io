#!/usr/bin/env bash

set -x
export NOW_YEAR="$(date +'%Y')"
export SITE_URL="https://pjoc.pub"

echo 'cat <<END_OF_TEXT' >  mkdocs_temp.sh
cat mkdocs_tpl.yml                 >> mkdocs_temp.sh
echo 'END_OF_TEXT'       >> mkdocs_temp.sh
bash mkdocs_temp.sh > "mkdocs.yml"
rm mkdocs_temp.sh

cat mkdocs.yml
