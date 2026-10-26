#!/bin/zsh
token=$(security find-generic-password -s claude-code-oauth -w) || exit 1
container run --rm -it \
-c 8 -m 32G \
-v "$PWD:$PWD" -w "$PWD" \
-v claude-code-container-state:/root/.claude \
--mount "type=bind,source=$HOME/.claude/skills,target=/root/.claude/skills,readonly" \
-e CLAUDE_CODE_OAUTH_TOKEN="$token" \
claude-code-container claude --dangerously-skip-permissions "$@"
