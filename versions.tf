terraform {
#   backend "gcs" {
#     bucket = "advizir-dev-tfstate"
#     prefix = "terraform/state-new"
#   }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.73.0"
    }
  }
}
