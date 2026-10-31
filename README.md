# claude-code-container
 Run Claude Code in an isolated container on macOS using Apple's container CLI. Ships Amazon Corretto 25 and Maven for Java development,   keeps OAuth and Bedrock tokens in the macOS Keychain, and persists Claude state in `~/.c3` on the host. Run it with Anthropic or Amazon  Bedrock.

# Anthropic Setup

Start the Apple container system services:

```
container system start
```

Create the host directory that persists Claude state across container runs. It is a bind mount rather than a named volume, so several containers can share it at the same time:

```
mkdir -p ~/.c3
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

Put the `c3` script on your `PATH`, then start Claude Code in the container from any project directory. The current directory is mounted at the same path, Claude state comes from `~/.c3`, and `~/.claude/skills` is mounted read-only:

```
c3
```

Arguments are passed through to `claude`. The script reads the OAuth token from the Keychain and exits if the lookup fails. It requires `~/.c3` and `~/.claude/skills` to exist on the host.

# Parallel Instances

Run `c3` in several terminals to start multiple instances. All of them share the state in `~/.c3`, so history, memory, and settings are common. Two instances in the same directory edit the same working tree, so give each one its own checkout with `git worktree`:

```
git worktree add ../myproject-feature -b feature
cd ../myproject-feature && c3
```

Each container reserves 8 CPUs and 32 GB of memory. Lower the `-c` and `-m` values in `c3` if the runtime refuses to start additional instances.

# Alternative: Named Volume

Instead of the host directory, Claude state can live in a named volume managed by `container`. A volume is a disk image attached to the container's VM, so the state is not visible on the host filesystem. The trade-off is that a volume can be attached to only one container at a time. A second instance fails with `The storage device attachment is invalid`, so this approach does not support parallel instances.

Create the volume:

```
container volume create claude-code-container-state
```

Then replace the state mount in `c3`:

```
-v claude-code-container-state:/root/.claude \
```

To move existing volume state into the host directory, copy it once and remove the volume:

```
container run --rm -v claude-code-container-state:/src -v "$HOME/.c3:/dst" \
  claude-code-container cp -a /src/. /dst/
container volume delete claude-code-container-state
```

# Updating Claude Code

Claude Code is installed into the image at build time and the autoupdater is disabled. A plain `container build` reuses the cached install layer, so rebuild without the cache to pick up the latest version:

```
container build --no-cache -t claude-code-container
```
