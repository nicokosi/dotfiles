snap-list() {
  snap list |tail --lines=+2 |cut -d' ' -f1 |sort |uniq
}
