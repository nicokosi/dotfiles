# Vidal env vars
set -gx INSTALL4J_HOME_5_1_15 "/opt/install4j5"
set -gx INSTALL4J_HOME_7_0_9 "/opt/install4j7"
set -gx OTEL_EXPORTER_OTLP_ENDPOINT "http://otel.dockersw.vidal.net"
# For npm front-end tests that require Chrome:
set -gx CHROME_BIN "/opt/google/chrome/chrome"

# Docker remote host wrappers (inline VAR=val not supported in fish)
function dockersw
    env DOCKER_HOST="tcp://dockersw.vidal.net:4243" docker $argv
end

function dockerbo
    env DOCKER_HOST="tcp://dockerbo.vidal.net:4243" docker $argv
end

function dockertestsims
    env DOCKER_HOST="tcp://srv-vid-tux242.france.groupe.intra" docker $argv
end

function ctop-dockersw
    env DOCKER_HOST="tcp://dockersw.vidal.net:4243" ctop -a $argv
end

function ctop-dockerbo
    env DOCKER_HOST="tcp://dockerbo.vidal.net:4243" ctop -a $argv
end

function dockersw2
    env DOCKER_HOST="tcp://dockersw2.vidal.net:2376" docker \
        --tlsverify \
        --tlscacert=$HOME/.dotfiles/docker/dockersw2/ca.pem \
        --tlscert=$HOME/.dotfiles/docker/dockersw2/cert.pem \
        --tlskey=$HOME/.dotfiles/docker/dockersw2/key.pem \
        $argv
end

function gdl
    if test -e ./gradlew
        ./gradlew $argv
    else
        gradle $argv
    end
end

# Maven / XML aliases
alias mvn-deps-tree-vidal="mvn dependency:tree -Dincludes='com.vidal*:*:*:*'"
alias mvn-version="xmlstarlet sel -N ns='http://maven.apache.org/POM/4.0.0' -t -c '/ns:project/ns:version/text()' -n pom.xml"

# Script shortcuts
alias check-merges=~/.dotfiles/vidal/check-merges.sh
alias git-multi-fetch=~/.dotfiles/vidal/git-multi-fetch.sh
alias git-multi-tag-list=~/.dotfiles/vidal/git-multi-tag-list.sh
