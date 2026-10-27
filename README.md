# Teambition Release Notes for Codex

Generate a player-facing update announcement from a specified Teambition project and sprint. The skill produces one linked review draft, a task-by-task audit table, and a list of tasks outside its candidate criteria.

## Install

Ask Codex to install `https://github.com/NINI-YUL/teambition-release-notes/tree/main/skills/teambition-release-notes` with `$skill-installer`. Alternatively, copy `skills/teambition-release-notes` into your Codex skills directory, usually `%USERPROFILE%\.codex\skills\teambition-release-notes`. Keep `SKILL.md` and `scripts/` together. The installer copies this skill only; it does not install other skills or configure Teambition access.

Use `$teambition-release-notes` in Codex and specify the project and exact sprint name. For example: `Use $teambition-release-notes to draft the update announcement for the named project and sprint.`

## Prerequisites

- Preferred: connect Teambition MCP (`https://open.teambition.com/api/mcp/v2`), authorize with your own account, and confirm access to the requested project and tasks. The skill uses those MCP tools directly; no other skill is required. This repository does not provide credentials or project data.
- Optional CLI fallback: install the npm package `@tng/teambition-mcp-cli`, which provides the `teambition-cli` command (also available as `teambition`), and authorize it with your own account. On Windows, `scripts/collect-sprint-tasks.ps1` can collect paginated tasks through that CLI. Neither the CLI nor PowerShell script is needed when MCP tools are available. The separate `teambition` skill may help with CLI documentation but is not required; `teambition-statistics` is not used.
- If neither MCP nor an authorized CLI is available, configure one of them before requesting an announcement. Installation of this skill does not automatically install or authenticate either integration.
- Review the draft and confirm the actual release scope before publishing. Copy as plain text or remove internal Teambition links from the player-facing channel.

## Verify

After installing, invoke `$teambition-release-notes` in Codex with a project and an exact sprint name. Confirm that the Teambition MCP tools can list the sprint and read its tasks; a visible skill alone does not prove data access. If using the optional CLI fallback instead, run `teambition auth status` (expect `mcp2: yes`) and `teambition-cli project task-query --help` in the same environment before collecting data. The CLI package name is `@tng/teambition-mcp-cli`, not `teambition-cli`.

Do not commit tokens, OAuth callbacks, task exports, or other internal project data to this repository.
