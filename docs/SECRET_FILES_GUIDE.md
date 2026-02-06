# Secret Files Guide

## Quick Answer: Which file should I use?

### TL;DR
- **Use `~/.localrc`** - Simple, loaded first, for any secret configuration
- **Use `~/.env-vars`** - Only if you specifically want to separate environment variables

## The Two Options Explained

This dotfiles repository provides two ways to store secrets locally:

### Option 1: `~/.localrc` (Recommended for Most Users)

**What is it?**
- A file in your home directory: `~/.localrc`
- Loaded very early in ZSH startup (before dotfiles)
- Can contain any shell code

**When to use:**
- You want a single file for all your secrets
- You need to define aliases, functions, or complex configuration
- You're starting fresh and want simplicity

**Example `~/.localrc`:**
```bash
# API tokens
export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"
export OPENAI_API_KEY="sk-xxxxxxxxxxxx"

# Private aliases
alias prod-ssh="ssh user@production-server.example.com"

# Private functions
function deploy() {
    echo "Deploying with secret credentials..."
    # your deployment logic here
}

# Private PATH additions
export PATH="$HOME/secret-tools:$PATH"
```

### Option 2: `~/.env-vars` (For Environment Variables Only)

**What is it?**
- A file in your home directory: `~/.env-vars`
- Loaded later, via `private/env-vars.zsh` from the dotfiles
- Should contain only `export` statements

**When to use:**
- You already have `~/.localrc` and want to separate environment variables
- You want your environment variables loaded after other dotfiles setup
- You prefer organizing by file type

**Example `~/.env-vars`:**
```bash
# ONLY environment variable exports
export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"
export AWS_ACCESS_KEY_ID="AKIAXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxx"
export OPENAI_API_KEY="sk-xxxxxxxxxxxx"
```

## Loading Order

When ZSH starts with these dotfiles:

```
1. ~/.zshrc (from zsh/zshrc.symlink) begins loading
   ↓
2. ~/.localrc is sourced (if it exists) ← FIRST
   ↓
3. All dotfiles/**/*.zsh files are loaded, including:
   - private/env-vars.zsh which sources ~/.env-vars (if it exists) ← SECOND
   ↓
4. Rest of ZSH configuration continues
```

**Important**: Variables from `~/.localrc` are available before variables from `~/.env-vars`.

## Common Questions

### Q: Can I use both files?
**A:** Yes! Use `~/.localrc` for general secrets and `~/.env-vars` for additional environment variables. But for most users, just `~/.localrc` is sufficient.

### Q: I heard about `~/env-vars.zsh` - what's that?
**A:** That doesn't exist! You might be thinking of:
- `~/.env-vars` (no `.zsh`) - your local file for environment variables
- `private/env-vars.zsh` - the tracked file that loads `~/.env-vars`

### Q: Which should I use if I'm starting fresh?
**A:** Use `~/.localrc` - it's simpler and more flexible.

### Q: What if I need variables loaded in a specific order?
**A:** Put everything in `~/.localrc` in the order you need.

### Q: Are these files backed up?
**A:** NO! That's the point - they stay on your local machine and are never committed to the repository. Make sure to back them up separately if needed.

## Setup Instructions

### Using ~/.localrc (Recommended)

1. Create the file:
   ```bash
   touch ~/.localrc
   chmod 600 ~/.localrc  # Make it readable only by you
   ```

2. Add your secrets:
   ```bash
   echo 'export GITHUB_TOKEN="your_token_here"' >> ~/.localrc
   ```

3. Test it:
   ```bash
   source ~/.zshrc
   echo $GITHUB_TOKEN
   ```

### Using ~/.env-vars (Alternative)

1. Create the file:
   ```bash
   touch ~/.env-vars
   chmod 600 ~/.env-vars  # Make it readable only by you
   ```

2. Add your environment variables:
   ```bash
   echo 'export GITHUB_TOKEN="your_token_here"' >> ~/.env-vars
   ```

3. Test it:
   ```bash
   source ~/.zshrc
   echo $GITHUB_TOKEN
   ```

## Security Best Practices

1. **Never commit these files** - They're in `.gitignore`, but be careful
2. **Set restrictive permissions**: `chmod 600 ~/.localrc ~/.env-vars`
3. **Back them up securely** - Use encrypted backups
4. **Use environment-specific files** if needed (e.g., `.localrc.work`, `.localrc.personal`)
5. **Rotate credentials** if you accidentally expose them

## Migration Guide

### From ~/.env-vars to ~/.localrc

If you want to simplify and use just one file:

```bash
# Copy your env-vars to localrc
cat ~/.env-vars >> ~/.localrc

# Remove env-vars (optional)
rm ~/.env-vars

# Test
source ~/.zshrc
```

### From ~/.localrc to both files

If you want to separate environment variables:

```bash
# Extract exports from localrc to env-vars
grep '^export' ~/.localrc > ~/.env-vars

# Remove exports from localrc
sed -i.bak '/^export/d' ~/.localrc

# Test
source ~/.zshrc
```

## See Also

- [SECURITY.md](../SECURITY.md) - Comprehensive security documentation
- [README.md](../README.md) - Dotfiles overview
- `zsh/zshrc.symlink` - Where `~/.localrc` is loaded
- `private/env-vars.zsh` - Where `~/.env-vars` is loaded
