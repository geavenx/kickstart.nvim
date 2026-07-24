<!-- ai-memory:start -->
## Long-term memory (ai-memory)

This project uses [ai-memory](https://github.com/akitaonrails/ai-memory)
for cross-session continuity.

**Default to the current project - always.** Every ai-memory tool
auto-scopes to the project resolved from your session's working
directory. **Do NOT pass `project`, `workspace`, or `cwd` arguments unless
the user explicitly references a *different* project by name** (e.g. "what
did we decide in the `other-app` project?"). Phrases like "this project",
"here", "we", "our work", and "where did we leave off" all mean the
*current* project, so call tools with no scoping args.

This default assumes the MCP client can identify the current agent
session. Static MCP clients in parallel sessions for the same user cannot
forward the real agent session id automatically; pass explicit
`workspace` + `project` / `scopes`, or use a session-aware bridge that
forwards the lifecycle-hook session id on MCP calls.

**Lifecycle hooks already capture every prompt and tool call
automatically.** Do not manually write routine notes. Only write durable
memory when the user explicitly asks to remember or annotate something
permanently.

### Use the installed ai-memory Agent Skills

Detailed tool-routing guidance lives in the installed ai-memory Agent
Skills. When a task matches an installed ai-memory Agent Skill, load and
follow that skill before calling ai-memory tools. The skills cover memory
retrieval, handoffs, durable pages, learning maintenance, and routing
install or refresh work.

### When you write a project rule, write it here

If you're about to write a durable project rule ("always X", "never
Y", "all PRs must ..."), write it in the project's canonical agent instruction file.
Many projects use CLAUDE.md for Claude Code and
AGENTS.md for Codex / OpenCode / Cursor / Gemini CLI / Grok Build CLI / Kimi Code,
but if the project says one file is canonical, use that file.

If the rule is a standing *user/team* preference that should apply to
every project (tech choices, code style, personal conventions), save it
to ai-memory's reserved global scope instead — the durable-pages skill
covers how. Default memory reads surface global-scope pages in every
project automatically.

### Refreshing this snippet

This block is maintained by ai-memory. Two ways to refresh it with the
latest binary's recommended copy:

- **From the agent** (no terminal needed): ask "refresh the ai-memory
  routing in this project". The agent calls `memory_install_self_routing`,
  picks the right filename for itself (Claude Code -> `CLAUDE.md`; Codex /
  OpenCode / Cursor / Gemini / Grok -> `AGENTS.md`; Kimi Code -> `AGENTS.md`),
  uses its Write / Edit tool to replace or append the returned
  `markered_block` while preserving
  non-ai-memory user content, then writes or updates each returned
  `managed_skills` item under the selected skill root from `target_hints`
  using its `relative_path`.
- **From the CLI**: `ai-memory install-instructions` (defaults to
  `CLAUDE.md`; pass `--target AGENTS.md` for non-Claude agents or projects
  that use `AGENTS.md` as the canonical instruction file).

Both are idempotent: re-runs replace the block delimited by the ai-memory
start/end HTML-comment markers, without disturbing the rest of the file.
<!-- ai-memory:end -->

## Neovim Lua configuration conventions

Apply these conventions when creating or reorganizing this configuration:

- Keep `init.lua` as a small, deterministic composition root. Set
  `mapleader` and `maplocalleader` before loading mappings or plugins, then
  explicitly load core settings and feature modules in dependency order.
- Put project-owned modules under `lua/core/` and `lua/plugins/`. This project
  intentionally does not add a personal namespace beneath `lua/`.
- Organize modules by cohesive responsibility or user-facing feature, such as
  `core/options.lua`, `core/keymaps.lua`, `plugins/lsp.lua`, and
  `plugins/navigation.lua`. Do not split code into one-function files merely
  to make files shorter.
- Prefer explicit `require()` lists. Directory-scanning loaders are acceptable
  only when every discovered module is independent and execution order is
  irrelevant; never rely on filesystem iteration order.
- Keep dependency flow one-way: the entry point may load feature modules, and
  feature modules may use small shared utilities, but utilities must not load
  features. Avoid circular module dependencies.
- Use a consistent module interface. Prefer a returned table with an explicit
  `setup()` function when execution order, reuse, or testing matters; direct
  side effects on `require()` are acceptable for small, single-purpose leaf
  modules.
- Use native runtime directories for their intended scopes: `ftplugin/` for
  filetype configuration, `after/` for late overrides, `plugin/` for scripts
  that must be sourced automatically, and `lua/` for modules loaded with
  `require()`.
- Keep plugin installation, build/update hooks, and plugin configuration
  conceptually separate when using `vim.pack`. Group plugin configuration by
  feature where that improves cohesion.
- Keep variables and helper functions `local`. Do not add globals unless a
  Neovim or plugin API requires them. Use `pcall(require, ...)` only for truly
  optional dependencies; required-module failures should remain visible.
- Create autocommands with named augroups and `clear = true` so re-sourcing is
  idempotent. Give keymaps a meaningful `desc`, prefer Lua callbacks, and use
  buffer-local mappings and settings when their scope is buffer-specific.
- Do not introduce lazy loading or abstraction solely for presumed startup
  gains. Measure with `--startuptime` first. Treat `vim.loader.enable()` as an
  optional experimental optimization, not a structural dependency.
- Format Lua with StyLua and retain useful LuaLS annotations. After structural
  changes, at minimum run a headless startup smoke test with
  `nvim --headless '+qa'`; use `:checkhealth` and startup profiling when the
  affected area warrants them.
