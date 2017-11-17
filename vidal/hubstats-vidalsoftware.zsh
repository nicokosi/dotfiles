hubstats-vidalsoftware() {
  for r in 'arthur' 'morgane' 'api-installer' 'cdrom-installer' 'perceval' 'perceval-installer' 'vidal-express' 'tratracer' 'vidal-rules' 'memo-tracer' 'memo-rules' 'vidal-menu' 'vidal-update' 'vidal-menu-installer' 'vidal-menu-client' 'vigie' 'api-versions' 'software-parent-pom';
    do hubstats --organization softwarevidal --repository $r --token $GITHUB_TOKEN $*;
  done
}
