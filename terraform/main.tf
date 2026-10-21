terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "deployment_info" {
  filename = "${path.module}/deployment-info.txt"

  content = <<-EOT
  Project: VLE-8 Blue-Green Deployment
  Container runtime: Docker
  Orchestration: Kubernetes (K3s)
  Deployment strategy: Blue-Green
  Blue deployment: blue-deployment
  Green deployment: green-deployment
  Kubernetes service: vle8-service
  Service NodePort: 30080
  EOT
}

output "deployment_info_file" {
  value = local_file.deployment_info.filename
}
