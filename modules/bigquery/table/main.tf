resource "google_bigquery_table" "table" {
    project = var.project_id
    dataset_id          = var.dataset_id
    table_id            = var.table_id
    schema              = var.schema
    deletion_protection = var.deletion_protection
}
