# claude-code-container
 Run Claude Code in an isolated container on macOS using Apple's container CLI. Ships Amazon Corretto 25 and Maven for Java development,   keeps OAuth and Bedrock tokens in the macOS Keychain, and persists Claude state in a named volume. Run it with Anthropic or Amazon  Bedrock.

# Anthropic Setup

Start the Apple container system services:

```
container system start
```

Create a named volume that persists Claude state across container runs:

```
container volume create claude-code-container-state
```

Build the container image and tag it as `claude-code-container`:

```
container build -t claude-code-container
```

Generate a long-lived Claude Code OAuth token for your Anthropic account:

```
claude setup-token
```

Store the generated token in the macOS Keychain under the service name `claude-code-oauth` (you'll be prompted to paste it):

```
security add-generic-password -a "$USER" -s claude-code-oauth -w
```

# Running

Put the `c3` script on your `PATH`, then start Claude Code in the container from any project directory. The current directory is mounted at the same path, Claude state comes from the named volume, and `~/.claude/skills` is mounted read-only:

```
c3
```

Arguments are passed through to `claude`. The script reads the OAuth token from the Keychain and exits if the lookup fails. It requires `~/.claude/skills` to exist on the host.

# Updating Claude Code

Claude Code is installed into the image at build time and the autoupdater is disabled. A plain `container build` reuses the cached install layer, so rebuild without the cache to pick up the latest version:

```
container build --no-cache -t claude-code-container
```
