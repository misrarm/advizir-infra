resource "google_bigquery_table" "default" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "ccaip_details"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "dev"
  }

  schema = <<EOF
[
  {
    "name": "id",
    "type": "INTEGER",
    "mode": "NULLABLE",
    "description": "The id"
  },
  {
    "name": "type",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "the type"
  },
  {
    "name": "entity_type",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "the entity type"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "the user id"
  },
  {
    "name": "agent_id",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "the agent id"
  }
]
EOF

}
