provider "google" {
  project = "boxboat-dev"
  region  = "us-central1"
  zone    = "us-central1-c"
}

terraform {
  required_version = "0.13.1"

  backend "gcs" {
    bucket = "df-bq"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.73.0"
    }
  }
}
