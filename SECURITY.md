# Security Policy

## Overview

This dotfiles repository is designed with security in mind to prevent accidental leakage of sensitive information such as authentication tokens, API keys, passwords, and other credentials.

## Security Scan Results

A comprehensive security scan was performed on this repository with the following checks:

✅ **No hardcoded authentication tokens found** (GitHub, AWS, Stripe, Slack, etc.)  
✅ **No credential files committed** (.env, .pem, .key, SSH keys)  
✅ **No secrets in git history**  
✅ **Proper .gitignore configuration** to prevent credential leaks  
✅ **Environment variables handled securely** via the private/env-vars.zsh pattern

## Secure Practices

### 1. Environment Variables

This repository uses a secure pattern for handling environment variables:

- **File**: `private/env-vars.zsh`
- **Purpose**: Sources `~/.env-vars` file (which is NOT committed to the repository)
- **Usage**: Store all sensitive environment variables in `~/.env-vars` on your local machine

Example `~/.env-vars` file (create this locally, do NOT commit):
```bash
export GITHUB_TOKEN="your_token_here"
export AWS_ACCESS_KEY_ID="your_key_here"
export AWS_SECRET_ACCESS_KEY="your_secret_here"
```

### 2. Git Configuration

The repository includes git configuration templates that:
- Use OS keychain for credential storage (`osxkeychain` on macOS)
- Do NOT include actual credentials in the repository
- Personal git configuration (`git/gitconfig.symlink`) is gitignored

### 3. Protected Files

The `.gitignore` file is configured to exclude common credential files:
- Environment files (`.env`, `.env.*`)
- Private keys (`.pem`, `.key`, `id_rsa`, etc.)
- Application credentials (`.aws/credentials`, `.npmrc`, etc.)
- SSH configuration files
- Password databases (`.kdbx`)

## Best Practices

When contributing to or using this repository:

1. **Never commit credentials directly** - Always use environment variables or external configuration files
2. **Use the env-vars pattern** - Store sensitive data in `~/.env-vars` locally
3. **Review before commit** - Use `git diff --cached` before committing to check for sensitive data
4. **Use credential helpers** - Configure git to use OS keychain or credential managers
5. **Audit regularly** - Periodically scan for accidentally committed secrets

## Secret Scanning

This repository should be regularly scanned using tools like:
- GitHub's built-in secret scanning (if enabled)
- [gitleaks](https://github.com/zricethezav/gitleaks)
- [truffleHog](https://github.com/trufflesecurity/trufflehog)
- [git-secrets](https://github.com/awslabs/git-secrets)

## Reporting Security Issues

If you discover a security vulnerability or accidentally committed credential:

1. **DO NOT** open a public issue
2. Immediately contact the repository owner
3. If a secret was committed, revoke/rotate the credential immediately
4. Consider using [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/) or `git filter-branch` to remove from history

## Credential Rotation

If a credential is accidentally committed:

1. **Immediately revoke** the exposed credential
2. **Generate a new** credential/token
3. **Remove from git history** using tools like BFG Repo-Cleaner
4. **Update** all systems using the old credential
5. **Review** security logs for any unauthorized access

## Additional Resources

- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [OWASP Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/)
- [Removing sensitive data from a repository](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
