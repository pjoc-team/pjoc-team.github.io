#!/usr/bin/env bash
rm -fr public
sh prepare.sh
docker run --rm -v "$(pwd)":/docs  -w /docs pjoc/mkdocs:sha-4780fa4 mkdocs build -d public
