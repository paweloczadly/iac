resource "github_repository" "repo" {
  name         = "eap-oczadly-io"
  description  = "Early access program for https://oczadly.io"
  visibility   = "private"
  homepage_url = "https://eap.oczadly.io"

  auto_init = false

  delete_branch_on_merge = true

  has_issues   = false
  has_wiki     = false
  has_projects = false
}

resource "github_actions_repository_permissions" "write_permissions" {
  repository      = github_repository.repo.name
  allowed_actions = "all"
}
