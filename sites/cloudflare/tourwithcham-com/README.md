# tourwithcham.com

OpenTofu configuration for the `tourwithcham.com` Cloudflare Pages Direct Upload project, custom domain, and DNS record.

## Prerequisites

- The `tourwithcham.com` zone exists in the Cloudflare account.
- `CLOUDFLARE_API_TOKEN` is set.
- `cloudflare_account_id` and `cloudflare_zone_id` are provided locally.

## Apply

```bash
tofu init
tofu plan
tofu apply
```

The website repository deploys the static assets with GitHub Actions and Wrangler. Configure these GitHub Actions repository secrets:

- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_API_TOKEN`

The API token requires `Account > Cloudflare Pages > Edit` for the account that owns this project. Every push to `main` triggers a production deployment.
