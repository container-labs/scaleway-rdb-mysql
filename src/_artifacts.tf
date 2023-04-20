locals {
  data_authentication = {
    username = module.database_mysql.username
    password = module.database_mysql.password
    hostname = module.database_mysql.hostname
    port     = module.database_mysql.port
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
        engine  = "mysql"
        version = var.mysql_version
      }
    }
  }
}

resource "massdriver_artifact" "authentication" {
  field                = "authentication"
  provider_resource_id = module.database_mysql.id
  name                 = "Scaleway MySQL Instance"
  artifact             = jsonencode(local.artifact)
}
