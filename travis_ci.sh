#!/usr/bin/env bash
docker run --rm --entrypoint= -it -v ~/.ssh:/root/.ssh -v `pwd`:/project skandyla/travis-cli /bin/sh
