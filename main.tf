locals {
  project_id = var.project_id
  datasets = jsondecode(file(var.datasets_config))["datasets"]

  location = var.location

  scheduled_query_input_stats_table = var.scheduled_query_input_stats_table
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
  source        = "git@github.com:misrarm/advizir-modules//modules/bigquery/dataset?ref=v1.0.0"
  for_each      = local.datasets
  project_id    = local.project_id
  dataset_id    = each.value["dataset_id"]
  friendly_name = each.value["friendly_name"]
  location = local.location
}

module "table" {
  source = "git@github.com:misrarm/advizir-modules//modules/bigquery/table?ref=v1.0.0"
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

# module "scheduled_queries" {
#   source = "git@github.com:misrarm/advizir-modules//modules/bigquery/scheduled_queries?ref=v1.0.0"

#   project_id = local.project_id

#   queries = [
#     {
#       name                   = "insert-stats-query"
#       location               = local.location
#       data_source_id         = "scheduled_query"
#       destination_dataset_id = "svav_dev_dataset_test"
#       schedule = "every day 16:00"
#       params = {
#         destination_table_name_template = "table_stats"
#         write_disposition               = "WRITE_APPEND"
#         query                           = "SELECT COUNT(DISTINCT ARRAY_REVERSE(SPLIT(a.conversation_name,'/'))[SAFE_OFFSET(0)]) AS count,  CURRENT_DATETIME('America/Los_Angeles') AS current_datetime,  DATETIME_SUB(CAST(CURRENT_DATE() AS DATETIME), INTERVAL 3 HOUR) AS low,  DATETIME_ADD(CAST(CURRENT_DATE() AS DATETIME), INTERVAL 9 HOUR) AS high FROM  `${local.scheduled_query_input_stats_table}` a WHERE  DATETIME(request_time, 'America/Los_Angeles') BETWEEN DATETIME_SUB(CAST(CURRENT_DATE() AS DATETIME), INTERVAL 3 HOUR)  AND DATETIME_ADD(CAST(CURRENT_DATE() AS DATETIME), INTERVAL 9 HOUR)"

#         # insert into `gcp-abs-svav-dev-prj-01.svav_dev_dataset_test.table_stats`
#       }
#     },
#     {
#       name                   = "insert-errors-query"
#       location               = local.location
#       data_source_id         = "scheduled_query"
#       destination_dataset_id = "svav_dev_dataset_test"
#       schedule = "every day 16:00"
#       params = {
#         destination_table_name_template = "table_errors"
#         write_disposition               = "WRITE_APPEND"
#         query                           = "SELECT CAST(JSON_VALUE(g.message) AS string) AS Webhook_Message, COUNT(*) AS Webhook_failures_Count, CURRENT_DATETIME('America/Los_Angeles') AS current_datetime, DATETIME_SUB(CAST(CURRENT_DATE() AS DATETIME), INTERVAL 3 HOUR) AS low, DATETIME_ADD(CAST(CURRENT_DATE() AS DATETIME), INTERVAL 9 HOUR) AS high FROM `${local.scheduled_query_input_stats_table}` a LEFT JOIN UNNEST(JSON_QUERY_ARRAY(a.response,\"$.queryResult.webhookStatuses\")) g LEFT JOIN UNNEST(JSON_QUERY_ARRAY(a.conversation_signals,\"$.turnSignals.failureReasons\")) c WHERE DATETIME(request_time, 'America/Los_Angeles') BETWEEN DATETIME_SUB(CAST(CURRENT_DATE() AS DATETIME), INTERVAL 3 HOUR) AND DATETIME_ADD(CAST(CURRENT_DATE() AS DATETIME), INTERVAL 9 HOUR) AND JSON_VALUE(g.message) IS NOT NULL GROUP BY 1 ORDER BY 1;"
#       }
#     }
#   ]

#   depends_on = [ module.table ]
# }

