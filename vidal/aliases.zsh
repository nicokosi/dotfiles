alias dockersw="DOCKER_HOST=\"tcp://dockersw.vidal.net:4243\" docker"
alias mvn-deps-tree-vidal="mvn dependency:tree -Dincludes=\"com.vidal*:*:*:*\""
alias mvn-version="xmlstarlet sel -N ns=\"http://maven.apache.org/POM/4.0.0\" -t -c \"/ns:project/ns:version/text()\" -n pom.xml"
alias check-merges=~/.dotfiles/vidal/check-merges.sh
alias git-multi-fetch=~/.dotfiles/vidal/git-multi-fetch.sh
