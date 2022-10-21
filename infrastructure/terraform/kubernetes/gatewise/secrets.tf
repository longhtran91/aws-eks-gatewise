data "aws_secretsmanager_secret_version" "gatewise_web" {
  secret_id = "gatewise/web"
}

resource "kubernetes_secret_v1" "gatewise_web" {
  metadata {
    name = "gatewise-web"
  }

  data = {
    "KEY"           = jsondecode(data.aws_secretsmanager_secret_version.gatewise_web.secret_string)["key"]
    "REFRESH_TOKEN" = jsondecode(data.aws_secretsmanager_secret_version.gatewise_web.secret_string)["refresh_token"]
    "USER_AGENT"    = jsondecode(data.aws_secretsmanager_secret_version.gatewise_web.secret_string)["user_agent"]
    "DEVICE_TOKEN"  = jsondecode(data.aws_secretsmanager_secret_version.gatewise_web.secret_string)["device_token"]
  }
}