resource "google_bigquery_dataset" "dataset" {
  dataset_id                 = var.dataset_id
  friendly_name              = var.friendly_name
  description                = var.description
  location                   = var.location
  delete_contents_on_destroy = true

  labels = {
    project = "boxboat-dev"
    app     = "svav"
    env     = "dev"
  }

  access {
    role          = "OWNER"
    user_by_email = "jay@boxboat.com"
  }
}
