#!/usr/bin/env bash
docker run --rm -v `pwd`:/docs -w /docs pjoc/mkdocs:3d7cfb3 mkdocs build -d public
