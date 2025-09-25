resource "github_repository" "repo" {
  name        = "organization-template"
  description = "Opinionated yet minimal IaC structure using OpenTofu and AVM best practices."
  visibility  = "public"

  auto_init            = false
  is_template          = true
  vulnerability_alerts = true

  delete_branch_on_merge = true

  has_issues   = true
  has_wiki     = false
  has_projects = false
}

resource "github_branch" "branch_main" {
  repository = github_repository.repo.name
  branch     = "main"
}

resource "github_branch_default" "repo_default_branch" {
  repository = github_repository.repo.name
  branch     = github_branch.branch_main.branch
}

resource "github_branch_protection" "branch_protection_main" {
  repository_id = github_repository.repo.id
  pattern       = "main"

  required_pull_request_reviews {
    required_approving_review_count = 1
  }

  required_status_checks {
    contexts = []
    strict   = true
  }
}

resource "github_actions_repository_permissions" "write_permissions" {
  repository      = github_repository.repo.name
  allowed_actions = "all"
}
