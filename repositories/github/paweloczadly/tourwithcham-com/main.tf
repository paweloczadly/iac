resource "github_repository" "repo" {
  name         = "tourwithcham-com"
  description  = "Website for tourwithcham.com"
  visibility   = "private"
  homepage_url = "https://tourwithcham.com"

  auto_init = true

  delete_branch_on_merge = true

  ignore_vulnerability_alerts_during_read = true

  has_issues   = true
  has_wiki     = false
  has_projects = true
}

resource "github_actions_repository_permissions" "write_permissions" {
  repository      = github_repository.repo.name
  allowed_actions = "all"
}
