# Cloudsmith NPM Orb

A CircleCI orb to assist with downloading npm packages from and publishing npm packages to Cloudsmith.

---

## Getting started

The orb commands require the following environment variables to be set:

* `CLOUDSMITH_ORGANISATION` : The identity/slug of the Cloudsmith organisation to use when authenticating with OIDC. Defaults to "financial-times" if not set.
* `CLOUDSMITH_SERVICE_ACCOUNT` : The identity/slug of the Cloudsmith service account to use when authenticating with OIDC.

These are used to authenticate with Cloudsmith using OIDC and can be found in the [Cloudsmith UI](https://cloudsmith.io/).

---

## Documentation

[Main orb documentation page](https://circleci.com/developer/orbs/orb/ft-circleci-orbs/cloudsmith-npm)

You can also find more information on how to use this orb in our [tech-hub guide.](https://tech.in.ft.com/tech-topics/development-tools/package-management/cloudsmith/set-up-circleci-node-projects-to-use-cloudsmith)

---
