gdl() {
  if [[ -a ./gradlew ]]; then
    ./gradlew $*
  else
   gradle $*
  fi
}
