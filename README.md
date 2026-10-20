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