data "aws_secretsmanager_secret_version" "tls_cert" {
  secret_id = "wildcard.lhtran.com_ssl_fullchain_cert"
}

data "aws_secretsmanager_secret_version" "tls_key" {
  secret_id = "wildcard.lhtran.com_ssl_key"
}

resource "kubernetes_secret_v1" "lhtran_tls" {
  metadata {
    name      = "lhtran-tls"
    namespace = "default"
  }

  data = {
    "tls.crt" = "${data.aws_secretsmanager_secret_version.tls_cert.secret_string}"
    "tls.key" = "${data.aws_secretsmanager_secret_version.tls_key.secret_string}"
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "dockerhub_cred" {
  metadata {
    name = var.registry_name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.registry_server}" = {
          "username" = var.registry_username
          "password" = var.registry_password
          "email"    = var.registry_email
          "auth"     = base64encode("${var.registry_username}:${var.registry_password}")
        }
      }
    })
  }
}