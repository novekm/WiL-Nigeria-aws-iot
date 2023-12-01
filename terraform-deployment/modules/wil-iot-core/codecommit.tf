# Optional - Only necessary if you want a full Ampclify App running in AWS (not just localhost)

resource "aws_codecommit_repository" "codecommit_repo" {
  count           = var.create_codecommit_repo ? 1 : 0
  repository_name = var.codecommit_repo_name
  description     = var.codecommit_repo_description
  default_branch  = var.codecommit_repo_default_branch

  tags = merge(
    {
      "AppName" = var.app_name != null ? var.app_name : "${var.project_prefix}_app"
    },
    var.tags,
  )
}
