locals {
  data_authentication = {
    host     = scaleway_rdb_instance.main.private_network[0].hostname
    username = "root"
    password = random_password.root_user_password.result
    port     = scaleway_rdb_instance.main.private_network[0].port
  }

  data_infrastructure = {
    id = scaleway_rdb_instance.main.id
  }

  data_security = {
    iam = {
      "read/write" = {
        permission_set = "RelationalDatabasesReadOnly"
      }
    }
  }

  artifact = {
    data = {
      authentication = local.data_authentication
      infrastructure = local.data_infrastructure
      security       = local.data_security
    }
    specs = {
      scw = {}
    }
  }
}

resource "massdriver_artifact" "authentication" {
  field                = "authentication"
  provider_resource_id = scaleway_rdb_instance.main.id
  name                 = "a contextual name for the artifact"
  artifact             = jsonencode(local.artifact)
}
