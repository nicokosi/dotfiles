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
  echo "  in local repo..."
  rm -r /home/nkosinski/.m2/repository/com/vidal/**/*installer
  rm -r /home/nkosinski/.m2/repository/com/vidal/merlin/vxp-indexer
  rm -r /home/nkosinski/.m2/repository/com/vidal/merlin/native
  rm -r /home/nkosinski/.m2/repository/com/vidal/merlin/data
  echo "  clean installer projects..."
  mvn clean -f /home/nkosinski/work/api-installer
  mvn clean -f /home/nkosinski/work/cdrom-installer
  sudo /opt/apache-maven-3.3.9/bin/mvn clean -f /home/nkosinski/work/zapi-sdk
  echo "✅"

  echo "Misc file cleanup..."
  rm -r /home/nkosinski/work/api-installer/bin
  rm -r /home/nkosinski/work/perceval-installer/bin

  echo "Space after cleanup:"
  df -h | grep "/dev/sd"
}
