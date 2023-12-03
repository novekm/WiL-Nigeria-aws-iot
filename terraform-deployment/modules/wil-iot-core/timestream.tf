resource "aws_timestreamwrite_database" "timestream-db" {
  database_name = "${var.project_prefix}-db"

  tags = merge(
    {
      "AppName" = var.app_name != null ? var.app_name : "${var.project_prefix}_app"
    },
    var.tags,
  )
}

resource "aws_timestreamwrite_table" "timestream-table" {
  database_name = aws_timestreamwrite_database.timestream-db.database_name
  table_name    = "${var.project_prefix}-table"

  retention_properties {
    memory_store_retention_period_in_hours  = 24  // time in hours before data is transitioned to magnetic storage
    magnetic_store_retention_period_in_days = 365 // time in days data is retained in magnetic store until deleted
  }

  tags = merge(
    {
      "AppName" = var.app_name != null ? var.app_name : "${var.project_prefix}_app"
    },
    var.tags,
  )
}
