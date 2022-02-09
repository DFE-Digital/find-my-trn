resource "cloudfoundry_route" "fmt_public" {
  domain   = data.cloudfoundry_domain.cloudapps.id
  hostname = var.fmt_app_name
  space    = data.cloudfoundry_space.space.id
  port     = 3000
}

resource "cloudfoundry_app" "app" {
  name         = var.fmt_app_name
  space        = data.cloudfoundry_space.space.id
  instances    = var.fmt_instances
  memory       = var.fmt_memory
  disk_quota   = var.fmt_disk_quota
  docker_image = var.fmt_docker_image
  strategy     = "blue-green"

  routes {
    route = cloudfoundry_route.fmt_public.id
  }
}
