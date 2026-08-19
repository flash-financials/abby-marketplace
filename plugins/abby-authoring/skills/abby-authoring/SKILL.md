---
description: Author Abby App/Report bundles — create, validate, preview and publish reports that run inside the Abby platform. Use when the user asks for an Abby report or app, or mentions abbycli.
---

# Authoring Abby reports

Abby App/Report bundles are `metadata.yaml` + `main.mjs` projects that render as a
report or app inside Abby. The `abby-authoring` tools drive `abbycli`, which does
the work locally and talks to the user's Abby deployment for preview and publish.

## Before anything else

The tools need `abbycli` on PATH and a signed-in session. If a tool reports the
user is not signed in, tell them to run:

```
abbycli login --base-url <their deployment>
```

That must be the same deployment configured for this plugin. Their account needs
the **Developer Access** permission; without it sign-in is refused at the
authorization step and only an Abby administrator can grant it.

## The loop

`create` → edit the project → `check` → fix → `check` → `preview`.

- **create** scaffolds under `~/.abby/apps/<name>`. Projects live there and
  nowhere else, and are addressed by name.
- **check** is offline: metadata, dependencies, bundling and JS syntax. Errors
  carry a file, line and column — read them rather than guessing.
- **preview** stages a personal draft and returns a link the user can open.
- **publish** puts it in the user's own My Apps.

Start from a built-in example when one is close: `app-balance-sheet`,
`app-foundation`, `app-jsonb`, `app-router`, `app-sqlserver`, `app-template`,
`integration-bundle`, `todo`. They are synced to `~/.abby/examples/` — read them
as references; do not copy one wholesale into a new project.

## What is the user's call, not yours

Publishing is staged deliberately. `preview` only stages a draft in their
personal space. `publish` makes it theirs. Reaching the organization is a
separate, separately-gated step. Prepare all of it; let them decide what goes
live. You act as that user and can never exceed their permissions.

## Detail beyond this

The full syntax contract — resource kinds, dependency refs, parameter schemas,
output formats — is written into `AGENTS.md` and `CLAUDE.md` in each project by
`abbycli`, and stays current with the deployment. Read it there rather than
relying on this summary.
