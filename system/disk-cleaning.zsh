disk-cleanup() {
  echo "Space before cleanup:"
  df -h | grep "/dev/disk1"

  echo "Docker cleanup..."
  docker system prune --all --force
  docker rmi --force $(docker images --all --quiet)
  docker rm --force $(docker ps --all --quiet)
  #rm -r /var/lib/docker/aufs/diff
  echo "Docker cleanup ✅\n"

  echo "Maven cleanup (remove files from local repo)..."
  echo "  in local repo..."
  rm -r /Users/nicolas/.m2/repository/com/vidal/**/*installer
  rm -r /Users/nicolas/.m2/repository/com/vidal/merlin/vxp-indexer
  rm -r /Users/nicolas/.m2/repository/com/vidal/merlin/native
  rm -r /Users/nicolas/.m2/repository/com/vidal/merlin/data
  echo "  clean Vidal projects..."
  cd ~/work/vidal
  for project in `ls`; mvn clean -q -f $project/pom.xml
  echo "Maven cleanup ✅\n"

  echo "Misc file cleanup..."
  rm -r /Users/nicolas/work/vidal/api-installer/bin
  rm -r /Users/nicolas/work/vidal/perceval-installer/bin
  echo "Misc file cleanup ✅\n"

  echo "Space after cleanup:"
  df -h | grep "/dev/disk1"
}
