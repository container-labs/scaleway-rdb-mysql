locals {
  data_authentication = {
    hostname     = scaleway_rdb_instance.main.private_network[0].hostname
    username = "root"
    password = random_password.root_user_password.result
    port     = scaleway_rdb_instance.main.private_network[0].port
  }

  data_infrastructure = {
    # id = scaleway_rdb_instance.main.id
    # TODO: remove when there is an update to the redis-authentication artifact-definition
    name = "saymyname"
  }

  data_security = {
    iam = {
      "read_write" = {
        role = "roles/senior"
      }
    }
    # TODO: use when there is an update to the redis-authentication artifact-definition to add scaleway security
    # iam = {
    #   "read_write" = {
    #     permission_set = "RelationalDatabasesReadOnly"
    #   }
    # }
  }

  artifact = {
    data = {
      authentication = local.data_authentication
      infrastructure = local.data_infrastructure
      security       = local.data_security
    }
    specs = {
      rdbms = {
        engine = "mysql"
        version = var.mysql_version
      }
    }
  }
}

resource "massdriver_artifact" "authentication" {
  field                = "authentication"
  provider_resource_id = scaleway_rdb_instance.main.id
  name                 = "SCW MySQL Instance"
  artifact             = jsonencode(local.artifact)
}
