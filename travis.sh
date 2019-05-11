#!/usr/bin/env bash
args="$1"
docker run --rm -it -v $(pwd):/project -v $(pwd)/.travis:/root/.travis skandyla/travis-cli $args

