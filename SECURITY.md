# Security Policy

## Supported Versions

Security updates are provided for the latest stable release and the default development branch.

| Version        | Supported          |
| -------------- | ------------------ |
| Latest release | :white_check_mark: |
| main branch    | :white_check_mark: |
| Older releases | :x:                |

## Reporting a Vulnerability

Please do **not** open public issues for security vulnerabilities.

Use one of the following private channels instead:

1. GitHub Security Advisories: open a private report through the repository's Security tab.
2. If Security Advisories are unavailable, contact the maintainers directly through the repository owner contact listed on GitHub.
3. Send us an email at support@entilitystudio.com with subject `[SECURITY][Severity] Subject`.

When reporting, include:

- A clear description of the vulnerability.
- Steps to reproduce.
- Affected platform(s): Android, iOS, macOS, Linux, Windows.
- Potential impact.
- Any proof-of-concept, logs, or screenshots (with secrets removed).
- Suggested mitigation, if available.

## What to Expect

- Initial acknowledgement: within 5 business days.
- Triage and severity assessment: as soon as reproducibility is confirmed.
- Regular status updates: at key investigation milestones.
- Fix timeline: depends on severity and complexity.

## Disclosure Policy

- We will coordinate disclosure after a fix is available or a mitigation is documented.
- Please avoid public disclosure until maintainers confirm it is safe to share details.

## Security Best Practices for Contributors

- Never commit secrets, tokens, signing keys, or production credentials.
- Keep environment-specific values in local files and secure secret stores.
- Use least-privilege credentials for Third-party services.
- Validate all external inputs and handle untrusted clipboard content defensively.
- Keep dependencies updated and monitor advisories for Flutter, Dart, and plugins.
