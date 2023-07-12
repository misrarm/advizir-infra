locals {
  datasets = jsondecode(file("dataset.json"))["datasets"]
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
  source        = "./module/bigquery"
  for_each      = local.datasets
  dataset_id    = each.value["dataset_id"]
  friendly_name = each.value["friendly_name"]
}

module "table" {
  source = "./module/bigquery/table"
  for_each = {
    for dt in local.dataset_tables : "${dt.dataset_id}-${dt.table_id}" => dt
  }

  dataset_id          = each.value.dataset_id
  table_id            = each.value.table_id
  schema              = jsonencode(each.value.schema)
  depends_on          = [module.dataset]
  deletion_protection = false
}
