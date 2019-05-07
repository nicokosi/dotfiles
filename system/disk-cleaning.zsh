disk-cleanup() {
  echo "Space before cleanup:"
  df -h | grep "/dev/sd"

  echo "Docker cleanup..."
  sudo docker system prune --all --force --volumes
  docker rmi --force $(docker images --all --quiet)
  docker rm --volumes --force $(docker ps --all --quiet)
  #rm -r /var/lib/docker/aufs/diff
  echo "✅"

  echo "Maven cleanup (remove files from local repo)..."
  echo "  in local repo..."
  rm -r $HOME/.m2/repository/com/vidal/**/*installer
  rm -r $HOME/.m2/repository/com/vidal/merlin/vxp-indexer
  rm -r $HOME/nkosinski/.m2/repository/com/vidal/merlin/native
  rm -r $HOME/nkosinski/.m2/repository/com/vidal/merlin/data
  echo "  clean all Vidal Maven projects..."
  for pom in ~/work/*/pom.xml;
  	mvn clean --file $pom --quiet
  	mvn dependency:purge-local-repository --define snapshotsOnly --quiet
  echo "✅"

  echo "Misc file cleanup..."
  rm -r $HOME/work/api-installer/bin
  rm -r $HOME/work/perceval-installer/bin
  rm -r $HOME/work/perceval-installer/work

  echo "Spark cleanup..."
  rm --recursive --force /opt/spark-2.*-bin-hadoop*/work/**

  echo "SDKMAN! cleanup..."
  sdk flush archives && sdk flush temp && sdk flush broadcast

  echo "Space after cleanup:"
  df -h | grep "/dev/sd"
}
