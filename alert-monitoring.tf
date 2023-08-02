locals {

}

resource "google_monitoring_alert_policy" "alert_policy" {
  project = var.project_id
  display_name = "GKE Container - High CPU Limit Utilization (esgk-gke-res-prod-ue4-cluster-01 cluster)"
  combiner     = "OR"
  conditions {
    display_name = "GKE container in esgk-gke-res-prod-ue4-cluster-01 cluster has high CPU limit utilization"
    condition_threshold {
      filter     = "resource.type = \"k8s_container\" AND (resource.labels.cluster_name = \"esgk-gke-res-prod-ue4-cluster-01\" AND resource.labels.location = \"us-east4\") AND metric.type = \"kubernetes.io/container/cpu/limit_utilization\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = "0.0"
      aggregations {
        alignment_period = "300s"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_NONE"
      }
    }
  }

  user_labels = {
    foo = "bar"
  }
}
