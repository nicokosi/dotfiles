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
  rm -r /Users/nicolas/.m2/repository/com/vidal
  echo "  clean Vidal projects..."
  cd ~/work/vidal
  for project in `ls`
  do
    if [[ -a $project/pom.xml ]]
    then
      mvn-vidal -q -f $project/pom.xml clean
    fi
  done
  echo "Maven cleanup ✅\n"

  echo "Misc file cleanup..."
  rm -r /Users/nicolas/work/vidal/api-installer/bin
  rm -r /Users/nicolas/work/vidal/perceval-installer/bin
  echo "Misc file cleanup ✅\n"

  echo "SDKMAN! cleanup..."
  sdk flush archives && sdk flush broadcast && sdk flush temp

  echo "Space after cleanup:"
  df -h | grep "/dev/disk1"
}
