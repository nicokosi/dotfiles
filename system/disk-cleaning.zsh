disk-cleanup() {
  echo "Space before cleanup:"
  df -h | grep "/dev/sd"

  echo "Docker cleanup..."
  sudo docker system prune --all --force
  docker rmi --force $(docker images --all --quiet)
  docker rm --force $(docker ps --all --quiet)  
docker rm `docker ps -a -q`
  #rm -r /var/lib/docker/aufs/diff
  echo "✅"

  echo "Maven cleanup (remove files from local repo)..."
  rm -r /home/nkosinski/.m2/repository/com/vidal/**/*installer
  rm -r /home/nkosinski/.m2/repository/com/vidal/merlin/vxp-indexer
  rm -r /home/nkosinski/.m2/repository/com/vidal/merlin/native
  rm -r /home/nkosinski/.m2/repository/com/vidal/merlin/data
  echo "✅"

  echo "Space after cleanup:"
  df -h | grep "/dev/sd"
}
