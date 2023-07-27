terraform {
  backend "gcs" {
    bucket = "advizir-dev-tfstate"
    # bucket = "gcp-abs-svav-dev-prj-01-tfstate"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.73.0"
    }
  }
}
