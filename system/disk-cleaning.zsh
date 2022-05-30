#!/bin/zsh

disk-cleanup() {
  print "Space before cleanup:"
  df -h | grep "/dev/disk1"

  ls ~/Library/Caches | xargs rm -rf
  print "App cache cleanup 🖥\n"

  brew cleanup --prune=all
  print "Brew cleanup 🍻\n"

  docker system prune --all --force
  docker rmi --force "$(docker images --all --quiet)"
  docker rm --force "$(docker ps --all --quiet)"
  print "Docker cleanup 🐳\n"

  ls ~/.m2/repository | xargs rm -rf
  cd ~/work/vidal || exit
  for project in $(ls)
  do
    if [[ -a $project/pom.xml ]]
    then
      mvn-vidal -q -f "$project/pom.xml" clean
    fi
  done
  print "Maven cleanup 🪶\n"

  ls ~/.gradle/caches | xargs rm -rf
  for project in $(ls)
  do
    if [[ -a $project/build.gradle.kts ]]
    then
      ./gradlew clean
    fi
  done
  print "Gradle cleanup 🐘\n"

  ls ~/.ivy2/cache | xargs rm -rf
  print "Ivy cleanup 🐜\n"

  sdk flush archives && sdk flush broadcast && sdk flush temp
  print "SDKMAN! cleanup 🦸\n"


  rm -r /Users/nicolas/work/vidal/api-installer/bin
  rm -r /Users/nicolas/work/vidal/perceval-installer/bin
  print "Misc file cleanup 🧹\n"

  print "Space after cleanup:"
  df -h | grep "/dev/disk1"
}
