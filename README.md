# BetterUmami GTM Community Template

This repository contains a Google Tag Manager (GTM) Community Template for
[BetterUmami](https://app.betterumami.com/).

## Installation

1. In GTM, open **Templates** → **Tag Templates** → **New**.
2. Import `template.tpl` and save the template.
3. Open **Tags** → **New** and select **BetterUmami Analytics**.
4. Enter the Website ID from your BetterUmami website settings.
5. Configure the optional settings described below.
6. Add a trigger (normally **All Pages**) and publish the container.

No Website ID is stored by this template. Configure it in each GTM tag.

## Template fields

| Field | Data attribute equivalent | URL parameter |
| --- | --- | --- |
| Website ID | `data-website-id` | `website-id` |
| Performance | `data-performance` | `performance` |
| Do Not Track | `data-do-not-track` | `do-not-track` |
| Exclude Search | `data-exclude-search` | `exclude-search` |
| Exclude Hash | `data-exclude-hash` | `exclude-hash` |
| Enable Session Recording | — | loads `recorder.js` |

Enable **Do Not Track** to honor the visitor's browser DNT signal. **Exclude
Search** and **Exclude Hash** remove query strings and fragments from tracked
URLs.

The template loads `https://app.betterumami.com/script.js`. When session recording
is enabled, it loads `https://app.betterumami.com/recorder.js` after the main
tracker.

## Consent

The template reads GTM's **Analytics Storage** consent with `isConsentGranted`.
It does not load the tracker or recorder when consent is denied or unavailable.
Configure a consent banner or Consent Mode to grant or deny
`analytics_storage`, and trigger this tag again when consent changes.

## Direct installation compatibility

The existing `data-*` installation remains supported:

```html
<script
  defer
  src="https://app.betterumami.com/script.js"
  data-website-id="YOUR_WEBSITE_ID"
  data-performance="true"
  data-do-not-track="true"
  data-exclude-search="true"
  data-exclude-hash="true"
></script>
```

If replay is enabled, load the recorder with the same Website ID:

```html
<script
  defer
  src="https://app.betterumami.com/recorder.js"
  data-website-id="YOUR_WEBSITE_ID"
></script>
```

## Gallery publication

1. Create a public GitHub repository named `datasite-gtm-template`.
2. Include `template.tpl`, `metadata.yaml`, `LICENSE`, and `README.md`.
3. Commit and tag an initial release.
4. In Google Tag Manager, submit the template through the Community Template
   Gallery workflow.
5. Keep `metadata.yaml` versions aligned with release commit SHAs and describe
   changes in `changeNotes`.