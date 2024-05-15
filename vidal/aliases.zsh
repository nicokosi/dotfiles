alias dockersw="DOCKER_HOST=\"tcp://dockersw.vidal.net:4243\" docker"
alias dockerbo="DOCKER_HOST=\"tcp://dockerbo.vidal.net:4243\" docker"

alias ctop-dockersw="DOCKER_HOST=\"tcp://dockersw.vidal.net:4243\" ctop -a"
alias ctop-dockerbo="DOCKER_HOST=\"tcp://dockerbo.vidal.net:4243\" ctop -a"

alias dockersw2='DOCKER_HOST="tcp://dockersw2.vidal.net:2376" docker --tlsverify --tlscacert=$HOME/.dotfiles/docker/dockersw2/ca.pem --tlscert=$HOME/.dotfiles/docker/dockersw2/cert.pem --tlskey=$HOME/.dotfiles/docker/dockersw2/key.pem'

alias mvn-deps-tree-vidal="mvn dependency:tree -Dincludes=\"com.vidal*:*:*:*\""
alias mvn-version="xmlstarlet sel -N ns=\"http://maven.apache.org/POM/4.0.0\" -t -c \"/ns:project/ns:version/text()\" -n pom.xml"
alias check-merges=~/.dotfiles/vidal/check-merges.sh
alias git-multi-fetch=~/.dotfiles/vidal/git-multi-fetch.sh
alias git-multi-tag-list=~/.dotfiles/vidal/git-multi-tag-list.sh

alias gap="git add --patch"
