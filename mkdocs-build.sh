#!/usr/bin/env bash
rm -fr public
sh prepare.sh
docker run --rm -v "$(pwd)":/docs  -e LC_ALL=en_US.utf-8 -e LANG=en_US.utf-8 -e PYTHONIOENCODING=UTF-8 -w /docs pjoc/mkdocs:v0.0.14 mkdocs build -d public
