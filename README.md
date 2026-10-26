# Teambition Release Notes for Codex

Generate a player-facing update announcement from a specified Teambition project and sprint. The skill produces one linked review draft, a task-by-task audit table, and a list of tasks outside its candidate criteria.

## Install

Copy `skills/teambition-release-notes` into your Codex skills directory, usually `%USERPROFILE%\.codex\skills\teambition-release-notes`. Keep `SKILL.md` and `scripts/` together. Or install the skill from this repository with the Codex skill installer using the path `skills/teambition-release-notes`.

Use `$teambition-release-notes` in Codex and specify the project and exact sprint name. For example: `Use $teambition-release-notes to draft the update announcement for the named project and sprint.`

## Prerequisites

- Configure a Teambition MCP connection and authorize it with your own account. Access to the requested project is required. This repository does not provide credentials or project data.
- The optional `scripts/collect-sprint-tasks.ps1` fallback requires Windows PowerShell and `teambition-cli` with the user's own authorization. Codex can use the MCP tools directly when available; the script is not required for every announcement.
- Review the draft and confirm the actual release scope before publishing. Copy as plain text or remove internal Teambition links from the player-facing channel.

Do not commit tokens, OAuth callbacks, task exports, or other internal project data to this repository.
