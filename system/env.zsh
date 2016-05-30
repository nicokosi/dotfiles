#!/usr/bin/env bash

# jEnv configuration.
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

jenv enable-plugin maven > /dev/null 2>&1
