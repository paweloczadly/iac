resource "github_repository" "repo" {
  name        = "repository-template"
  description = "Template repository for new GitHub projects"
  visibility  = "public"

  auto_init        = true
  license_template = "mit"

  delete_branch_on_merge = true

  is_template  = true
  has_issues   = true
  has_wiki     = false
  has_projects = false

  vulnerability_alerts = true
}

resource "github_branch" "branch_main" {
  repository = github_repository.repo.name
  branch     = "main"
}

resource "github_branch_default" "repo_default_branch" {
  repository = github_repository.repo.name
  branch     = github_branch.branch_main.branch
}

resource "github_repository_file" "file" {
  for_each = fileset("${path.module}/files", "**")

  repository          = github_repository.repo.name
  branch              = github_branch.branch_main.branch
  file                = each.value
  content             = file("${path.module}/files/${each.value}")
  commit_message      = "chore: add ${each.value}"
  commit_author       = "Paweł Oczadły"
  commit_email        = "p@oczadly.io"
  overwrite_on_create = true
}
