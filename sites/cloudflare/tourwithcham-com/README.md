# tourwithcham.com

OpenTofu configuration for the `tourwithcham.com` Cloudflare Pages Direct Upload project, custom domain, DNS records, Turnstile widget, inquiry database, transactional email, inbound email routing, and private review-photo storage.

## Prerequisites

- The `tourwithcham.com` zone exists in the Cloudflare account.
- `CLOUDFLARE_API_TOKEN` is set.
- `cloudflare_account_id` and `cloudflare_zone_id` are provided locally.
- `TF_VAR_resend_api_key` contains a full-access Resend API key used only by OpenTofu.
- A free Resend account exists.

## Apply

```bash
tofu init
tofu plan -var-file=terraform.local.tfvars
tofu apply -var-file=terraform.local.tfvars
```

The website repository deploys the static assets with GitHub Actions and Wrangler. Configure these GitHub Actions repository secrets:

- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_API_TOKEN`

The API token requires the following permissions for the account that owns this project:

- `Account > Cloudflare Pages > Edit`
- `Account > D1 > Edit`
- `Account > Workers R2 Storage > Edit`
- `Account > Turnstile Sites > Edit`
- `Account > Email Routing Addresses > Edit`
- `Zone > Zone Settings > Edit`
- `Zone > Email Routing Rules > Edit`

Every push to `main` triggers a production deployment.

OpenTofu sets the zone Browser Cache TTL to `Respect Existing Headers`. This allows Pages `_headers` rules to require revalidation for mutable JavaScript and CSS while retaining the platform cache behavior for images.

## Turnstile

OpenTofu creates a managed Turnstile widget for `tourwithcham.com` and the project's `pages.dev` domain. The public site key and sensitive secret key are configured as Pages environment variables for production and preview deployments:

- `TURNSTILE_SITE_KEY`
- `TURNSTILE_SECRET_KEY`

The secret is stored in OpenTofu state. Keep the state file outside version control and restrict access to it.

## Transactional and inbound email

Customer confirmations and Chamara notifications are sent through Resend. Its free plan supports up to 3,000 transactional emails per month and 100 per day. Cloudflare Email Routing receives replies sent to `bookings@tourwithcham.com` and forwards them to the configured `inquiry_notification_destination` without creating another mailbox.

Export the Resend API key without writing it to a variable file:

```bash
export TF_VAR_resend_api_key="re_..."
```

OpenTofu creates the `tourwithcham.com` sending domain in Resend, reads the required DNS records from Resend, creates them in Cloudflare, and triggers domain verification. It also creates a separate `sending_access` API key restricted to this domain and injects only that key into Pages. The full-access management key remains exclusive to OpenTofu. Open and click tracking are disabled to avoid unnecessary visitor tracking. TLS is enforced and the sending region is `eu-west-1`.

Resend returns its DNS records only after creating the domain, so complete its setup in two stages:

1. Keep `enable_resend_domain_verification = false` and run `tofu apply`. This creates the Resend domain and stores the returned records in state.
2. Set `enable_resend_domain_verification = true` in the untracked `terraform.local.tfvars` file and run `tofu apply` again. This creates the Cloudflare DNS records and asks Resend to verify them.
3. If DNS propagation is not yet complete, wait briefly and rerun `tofu apply`.

The provider is pinned to the compatible `1.0.x` release line and its checksum is committed in `.terraform.lock.hcl`. Both API keys are sensitive values in OpenTofu state, and the sending key is also a sensitive Pages secret. Never commit either key or the local variable file.

Cloudflare requires the forwarding destination to be verified by email before it can be used in a routing rule. Complete setup in two stages:

1. Keep `enable_inquiry_email_routing_rule = false` and run `tofu apply`. This configures Email Routing DNS and sends a verification email to the destination mailbox.
2. Open the verification email and approve the destination address.
3. Set `enable_inquiry_email_routing_rule = true` and run `tofu apply` again. This creates the `bookings@tourwithcham.com` forwarding rule.

For Email Routing on the zone apex, the `cloudflare_email_routing_dns` resource intentionally omits `name`. Supplying `tourwithcham.com` there makes Cloudflare interpret it as a requested subdomain and reject it as not being a subdomain of itself.

The Pages runtime receives these values from OpenTofu in production and preview: `RESEND_API_KEY`, `INQUIRY_EMAIL_FROM`, `INQUIRY_REPLY_TO`, and `INQUIRY_NOTIFICATION_TO`. `notification_recipients` controls the comma-separated list passed to `INQUIRY_NOTIFICATION_TO`; by default both `paweloczadly@gmail.com` and `cnilanka87@gmail.com` receive inquiry and review notifications. This is intentionally separate from `inquiry_notification_destination`, which remains the single verified mailbox used by Cloudflare Email Routing. Email delivery remains best-effort and never removes an inquiry already stored in D1.

## Inquiry database

OpenTofu creates the EU-jurisdiction D1 database `tourwithcham-inquiries` and exposes it to production and preview Pages Functions through the `INQUIRIES_DB` binding. Database schema migrations are versioned and applied by the website repository's deployment workflow.

The GitHub Actions Cloudflare API token requires `Account > D1 > Edit` so the deployment workflow can apply pending migrations before uploading the application.

## Review photo storage

OpenTofu creates the EU-jurisdiction R2 bucket `tourwithcham-review-photos` and exposes it to production and preview Pages Functions through the `REVIEW_PHOTOS` binding.

The bucket has no public custom domain or `r2.dev` configuration. Review photos remain private objects and are returned only by the website function after it confirms that the corresponding review is approved in D1.

The API token used by OpenTofu requires `Account > Workers R2 Storage > Edit`. Application deployments do not upload objects and therefore do not require R2 write permission in the GitHub Actions deployment token.
