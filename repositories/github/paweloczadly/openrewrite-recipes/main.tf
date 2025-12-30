resource "github_repository" "repo" {
  name        = "openrewrite-recipes"
  description = "A collection of OpenRewrite recipes for code refactoring."
  visibility  = "public"

  has_issues   = true
  has_wiki     = false
  has_projects = false

  delete_branch_on_merge = true

  template {
    owner                = "paweloczadly"
    repository           = "repository-template"
    include_all_branches = true
  }
}

resource "github_actions_repository_permissions" "write_permissions" {
  repository      = github_repository.repo.name
  allowed_actions = "all"
}
