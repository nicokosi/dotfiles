export JAVA_HOME="/opt/jdk1.8.0_131"

# jEnv configuration.
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

jenv enable-plugin maven > /dev/null 2>&1
