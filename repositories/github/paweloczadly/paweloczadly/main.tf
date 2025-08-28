resource "github_repository" "repo" {
  name        = "paweloczadly"
  description = "Paweł Oczadły profile repository"
  visibility  = "public"

  auto_init        = true
  license_template = "mit"

  delete_branch_on_merge = true

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

resource "github_repository_file" "readme_md" {
  repository          = github_repository.repo.name
  branch              = github_branch.branch_main.branch
  file                = "README.md"
  content             = file("${path.module}/files/README.md")
  commit_message      = "feat(README): change profile README.md"
  commit_author       = "Paweł Oczadły"
  commit_email        = "p@oczadly.io"
  overwrite_on_create = true
}
