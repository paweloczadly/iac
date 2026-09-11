# eap.oczadly.io

OpenTofu configuration for the Cloudflare Pages project, custom domain, DNS record, and Cloudflare Access application protecting `eap.oczadly.io`.

The configuration also applies the EAP branding to the account-wide Access login page. Cloudflare uses this design for every Access application in the account.

## Prerequisites

- Connect GitHub account to Cloudflare Pages and grant it access to the private `eap-oczadly-io` repository.
- Complete the initial Cloudflare Zero Trust onboarding, including choosing a team name and activating a plan.
- Configure a Cloudflare API token through the provider's supported environment variables.

The One-time PIN identity provider is managed by this configuration and is the only login method enabled for the Access application.

## Configuration

Create a local `members.auto.tfvars` file. Files matching `*.tfvars` are ignored by this repository.

```hcl
cloudflare_account_id = "..."
cloudflare_zone_id    = "..."

member_emails = [
  "member@example.com",
]
```

Member email addresses are stored in the OpenTofu state even though the variable is marked as sensitive. Keep the state in a trusted location.

## Apply

```shell
tofu init
tofu plan
tofu apply
```

Preview deployments are disabled. The Access application also protects the production `pages.dev` address and its deployment subdomains so they cannot bypass the membership gateway.
