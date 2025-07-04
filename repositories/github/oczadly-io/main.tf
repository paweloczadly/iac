resource "github_repository" "repo" {
  name         = "oczadly.io"
  description  = "Blog and personal website for Paweł Oczadły."
  visibility   = "public"
  homepage_url = "https://oczadly.io"

  auto_init    = true
  has_issues   = true
  has_wiki     = false
  has_projects = false
  is_template  = false

  license_template = "mit"

  pages {
    cname = "oczadly.io"

    source {
      branch = "gh-pages"
      path   = "/"
    }
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
