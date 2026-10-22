# Application CI

Each application has a path-filtered `pull_request` workflow that calls its own
reusable check workflow:

- Go: `go-app/**`, `on-pull_request-go.yaml`, `wf-check-go.yaml`
- Node.js: `node-app/**`, `on-pull_request-node.yaml`, `wf-check-node.yaml`
- Deno: `deno-app/**`, `on-pull_request-deno.yaml`, `wf-check-deno.yaml`

Workflow paths above are relative to `.github/workflows/`. For example, a
Node.js-only PR does not run the Go or Deno checks; a PR changing both applications
runs both. Changes to unrelated files do not run application checks. The existing
repository-wide workflow linting and Renovate validation remain independent.

These workflows deliberately use the same native `paths` filtering as Go.
Do not make their conditional check names required unconditionally in branch
protection: GitHub can leave a path-skipped required workflow pending. Native path
filtering also inherits GitHub's changed-file limits.

## Node.js

Run from `node-app/`:

```sh
npm ci --ignore-scripts
npm run lint
npm run check
npm test
npm run build
npm audit --include=dev --audit-level=moderate
```

Biome checks formatting and recommended lint rules, plus an explicit ban on global
`eval`. TypeScript checks both application and test code; the build emits only
application code. Tests capture the real entrypoint's console output, and CI also
compares the built application's stdout with `Hello, World!\n`.

CI uses Node.js 24, a committed lockfile, and no dependency installation scripts.
If a future dependency requires an installation script, review it rather than
silently enabling all scripts.

## Deno

Run from `deno-app/`:

```sh
deno fmt --check
deno lint
deno task check
deno task test
deno task build
deno audit --frozen --level=moderate
```

CI pins the Deno version. Type checking, tests, compilation, and auditing use the
frozen lockfile. Tests capture the real entrypoint's console output, and CI also
compares the compiled executable's stdout with `Hello, World!\n`.
Neither tests nor the executable receive additional I/O permissions; permission
prompts are disabled.

## Security scope

Both check workflows use read-only repository permissions, disable persisted
checkout credentials, and pin external actions to commit SHAs. Audits run in
separate jobs so static/test failures do not suppress vulnerability reports.
Moderate-or-higher advisories fail CI; audits do not automatically modify
dependencies or ignore registry errors.

Audits query external vulnerability services with dependency metadata. They do not
prove that dependencies are benign or cover all dependency sources equally.
The greeting-only applications have no authentication, HTTP, or external-input
surface to exercise. Add security-specific tests and deeper security analysis when
those features are introduced. Periodic scanning, secret scanning, and publishing
attestations are not configured by these PR-only workflows.
