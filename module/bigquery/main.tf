resource "google_bigquery_dataset" "dataset" {
  dataset_id                 = var.dataset_id
  friendly_name              = var.friendly_name
  delete_contents_on_destroy = true
}

