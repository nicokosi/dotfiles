# jEnv configuration.
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

export JAVA_HOME=$( jenv javahome )

jenv enable-plugin maven > /dev/null 2>&1
