resource "github_repository" "repo" {
  name         = "oczadly.io"
  description  = "Blog and personal website for Paweł Oczadły."
  visibility   = "public"
  homepage_url = "https://oczadly.io"

  has_issues   = true
  has_wiki     = false
  has_projects = false

  delete_branch_on_merge = true

  template {
    owner      = "paweloczadly"
    repository = "blog-template"
    # include_all_branches = true
    include_all_branches = false // TODO: change me
  }

  lifecycle {
    ignore_changes = [pages]
  }
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
