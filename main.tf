locals {
  datasets = jsondecode(file("dataset.json"))["datasets"]
}

module "dataset" {
  source        = "./module/bigquery"
  for_each      = local.datasets
  dataset_id    = each.value["dataset_id"]
  friendly_name = each.value["friendly_name"]
  description   = each.value["description"]
  location      = each.value["location"]

  # labels = {
  #   project = "boxboat-dev"
  #   app     = "svav"
  #   env     = "dev"
  # }

  # access {
  #   role          = "OWNER"
  #   user_by_email = "jay@boxboat.com"
  # }
}


# resource "google_bigquery_table" "default" {
#   dataset_id = google_bigquery_dataset.dataset.dataset_id
#   table_id   = "ccaip_details"

#   time_partitioning {
#     type = "DAY"
#   }

#   labels = {
#     env = "dev"
#   }

#   schema = <<EOF
# [
#   {
#     "name": "id",
#     "type": "INTEGER",
#     "mode": "NULLABLE",
#     "description": "The id"
#   },
#   {
#     "name": "type",
#     "type": "STRING",
#     "mode": "NULLABLE",
#     "description": "the type"
#   },
#   {
#     "name": "entity_type",
#     "type": "STRING",
#     "mode": "NULLABLE",
#     "description": "the entity type"
#   },
#   {
#     "name": "user_id",
#     "type": "STRING",
#     "mode": "NULLABLE",
#     "description": "the user id"
#   },
#   {
#     "name": "agent_id",
#     "type": "STRING",
#     "mode": "NULLABLE",
#     "description": "the agent id"
#   }
# ]
# EOF

# }
