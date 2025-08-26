resource "github_repository" "repo" {
  name        = "blog-template"
  description = "Template repository for GitHub Pages blogs"
  visibility  = "public"

  auto_init        = true
  license_template = "mit"

  is_template  = true
  has_issues   = false
  has_wiki     = false
  has_projects = false

  lifecycle {
    ignore_changes = [pages]
  }
}

resource "github_branch" "branch_main" {
  repository = github_repository.repo.name
  branch     = "main"
}

resource "github_branch_default" "repo_default_branch" {
  repository = github_repository.repo.name
  branch     = github_branch.branch_main.branch
}

resource "github_repository_file" "index_html" {
  repository          = github_repository.repo.name
  branch              = "gh-pages"
  file                = "index.html"
  content             = file("${path.module}/files/index.html")
  commit_message      = "feat: add index.html file"
  commit_author       = "Paweł Oczadły"
  commit_email        = "p@oczadly.io"
  overwrite_on_create = true
  autocreate_branch   = true
}

resource "github_branch_protection" "branch_protection_main" {
  repository_id = github_repository.repo.id
  pattern       = github_branch.branch_main.branch

  required_pull_request_reviews {
    required_approving_review_count = 1
  }

  required_status_checks {
    contexts = []
    strict   = true
  }
}
