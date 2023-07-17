locals {
  project_id = var.project_id
  datasets = jsondecode(file(var.datasets_config))["datasets"]
  dataset_tables = flatten([
    for dataset, dataset_info in local.datasets : [
      for table, table_data in dataset_info.table_schema : {
        dataset_id    = dataset_info.dataset_id
        friendly_name = dataset_info.friendly_name
        table_id      = table_data.table_id
        schema        = table_data.schema
      }
    ]
  ])
}

module "dataset" {
  source        = "../svav-tf-modules/module/bigquery/dataset"
  for_each      = local.datasets
  project_id    = local.project_id
  dataset_id    = each.value["dataset_id"]
  friendly_name = each.value["friendly_name"]
}

module "table" {
  source = "../svav-tf-modules/module/bigquery/table"
  for_each = {
    for dt in local.dataset_tables : "${dt.dataset_id}-${dt.table_id}" => dt
  }

  project_id = local.project_id
  dataset_id          = each.value.dataset_id
  table_id            = each.value.table_id
  schema              = jsonencode(each.value.schema)
  depends_on          = [module.dataset]
  deletion_protection = false
}
