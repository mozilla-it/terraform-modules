locals {
  default_access = [
    {
      role          = "READER"
      special_group = "projectReaders"
    },
    {
      role          = "OWNER"
      special_group = "projectOwners"
    },
    {
      role          = "OWNER"
      user_by_email = var.owner_email
    },
  ]
}

resource "google_bigquery_dataset" "dataset" {
  project                    = var.project
  dataset_id                 = var.name
  description                = var.description
  location                   = var.location
  delete_contents_on_destroy = "false"

  dynamic "access" {
    for_each = [concat(
      local.default_access,
      [
        {
          "role"          = "OWNER"
          "user_by_email" = var.owner_email
        },
      ],
      var.extra_access,
    )]
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      domain         = lookup(access.value, "domain", null)
      group_by_email = lookup(access.value, "group_by_email", null)
      role           = lookup(access.value, "role", null)
      special_group  = lookup(access.value, "special_group", null)
      user_by_email  = lookup(access.value, "user_by_email", null)

      dynamic "view" {
        for_each = lookup(access.value, "view", [])
        content {
          dataset_id = view.value.dataset_id
          project_id = view.value.project_id
          table_id   = view.value.table_id
        }
      }
    }
  }

  labels = merge(
    var.extra_labels,
    {
      "mozilla_data_classification" = var.mozilla_data_classification
      "data_owner"                  = var.data_owner
      "data_consumer"               = var.data_consumer
      "data_source"                 = var.data_source
      "retention_period"            = var.retention_period
      "has_pii"                     = var.has_pii
    },
  )
}

