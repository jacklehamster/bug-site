# Deploying bug.dobuki.net

Static site, no build step, no dependencies.

## Deploy

    cd bug-site
    npx wrangler deploy

That uploads `public/index.html` and creates the custom domain
`bug.dobuki.net`, including the DNS record and SSL certificate.

## If it errors on the custom domain

Cloudflare refuses to create a Custom Domain when a DNS record for that
hostname already exists. If `bug.dobuki.net` is already in your DNS,
delete that record first, then run `wrangler deploy` again.

## Updating the script later

Replace `public/index.html` and run `npx wrangler deploy` again.

## Files

    wrangler.toml       config — worker name, assets dir, custom domain
    public/index.html   the whole site: hero, logline, 70-page reader
