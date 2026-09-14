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
  has_projects = false
}

resource "github_repository_file" "index" {
  repository = github_repository.repo.name
  branch     = "main"
  file       = "index.html"
  content    = file("${path.module}/files/index.html")

  commit_message      = "feat: add landing page"
  commit_author       = "Paweł Oczadły"
  commit_email        = "p@oczadly.io"
  overwrite_on_create = true
}

resource "github_repository_file" "site_asset" {
  for_each = setunion(
    fileset("${path.module}/files/assets", "*.jpg"),
    fileset("${path.module}/files/assets", "*.jpeg"),
  )

  repository = github_repository.repo.name
  branch     = "main"
  file       = ".site-assets/${each.value}.base64"
  content    = filebase64("${path.module}/files/assets/${each.value}")

  commit_message      = "feat: add ${each.value}"
  overwrite_on_create = true
}

resource "github_repository_file" "pages_deployment_workflow" {
  repository = github_repository.repo.name
  branch     = "main"
  file       = ".github/workflows/pages-deployment.yml"
  content    = file("${path.module}/files/.github/workflows/pages-deployment.yml")

  commit_message      = "ci: deploy to Cloudflare Pages"
  overwrite_on_create = true

  depends_on = [
    github_repository_file.index,
    github_repository_file.site_asset,
  ]
}

resource "github_actions_repository_permissions" "write_permissions" {
  repository      = github_repository.repo.name
  allowed_actions = "all"
}
