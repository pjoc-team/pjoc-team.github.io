#!/bin/bash
docker run --name mkdocs -d -v `pwd`:/docs -p 8000:8000 -w /docs pjoc/mkdocs:v0.0.11 mkdocs serve -a 0.0.0.0:8000
