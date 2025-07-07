resource "github_repository" "repo" {
  name        = "gradle-springinitializr-plugin"
  description = "Gradle plugin for bootstrapping Spring Boot projects using Spring Initializr. Production-ready with functional tests, build cache support, and idiomatic Gradle patterns."
  visibility  = "private"

  auto_init        = true
  license_template = "mit"

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

resource "github_actions_repository_permissions" "write_permissions" {
  repository      = github_repository.repo.name
  allowed_actions = "all"
}
