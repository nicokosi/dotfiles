disk-cleanup() {
  echo "Space before cleanup:"
  df -h | grep "/dev/sd"

  echo "Docker cleanup..."
  sudo docker system prune --all --force
  docker rmi --force $(docker images --all --quiet)
  docker rm --volumes --force $(docker ps --all --quiet)
  #rm -r /var/lib/docker/aufs/diff
  echo "✅"

  echo "Maven cleanup (remove files from local repo)..."
  echo "  in local repo..."
  rm -r /home/nkosinski/.m2/repository/com/vidal/**/*installer
  rm -r /home/nkosinski/.m2/repository/com/vidal/merlin/vxp-indexer
  rm -r /home/nkosinski/.m2/repository/com/vidal/merlin/native
  rm -r /home/nkosinski/.m2/repository/com/vidal/merlin/data
  echo "  clean all Vidal Maven projects..."
  for pom in ~/work/*/pom.xml; mvn clean -f $pom
  echo "✅"

  echo "Misc file cleanup..."
  rm -r /home/nkosinski/work/api-installer/bin
  rm -r /home/nkosinski/work/perceval-installer/bin
  rm -r /home/nkosinski/work/perceval-installer/work

  echo "Spark cleanup..."
  rm -r /opt/spark-2.1.1-bin-hadoop2.3/work/*

  echo "Space after cleanup:"
  df -h | grep "/dev/sd"
}
