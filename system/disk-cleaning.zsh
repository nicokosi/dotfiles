disk-cleanup() {
  echo "Space before cleanup:"
  df -h | grep "/dev/disk1"

  ls ~/Library/Caches | xargs rm -rf
  echo "App cache cleanup 🖥\n"

  brew cleanup --prune=all
  echo "Brew cleanup 🍻\n"

  docker system prune --all --force
  docker rmi --force $(docker images --all --quiet)
  docker rm --force $(docker ps --all --quiet)
  echo "Docker cleanup 🐳\n"

  ls ~/.m2/repository | xargs rm -rf
  cd ~/work/vidal
  for project in `ls`
  do
    if [[ -a $project/pom.xml ]]
    then
      mvn-vidal -q -f $project/pom.xml clean
    fi
  done
  echo "Maven cleanup 🪶\n"

  ls ~/.gradle/caches | xargs rm -rf
  for project in `ls`
  do
    if [[ -a $project/build.gradle.kts ]]
    then
      ./gradlew clean
    fi
  done
  echo "Gradle cleanup 🐘\n"

  ls ~/.ivy2/cache | xargs rm -rf
  echo "Ivy cleanup 🐜\n"

  sdk flush archives && sdk flush broadcast && sdk flush temp
  echo "SDKMAN! cleanup 🦸\n"


  rm -r /Users/nicolas/work/vidal/api-installer/bin
  rm -r /Users/nicolas/work/vidal/perceval-installer/bin
  echo "Misc file cleanup 🧹\n"

  echo "Space after cleanup:"
  df -h | grep "/dev/disk1"
}
