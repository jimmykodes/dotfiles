# Review: `zsh/themes/jimple/init.zsh`

_Originally reviewed at commit `a28da0f` (feat: lazy load pr number for prompt), 2026-11-25. Updated against the current state of the file to list only items that are still open._

All the bugs from the first review are fixed: the `gh --json` fields, the git status parsing (ahead/behind and dirty), the PR job race conditions, the cache key, `zmodload -F zsh/stat`, the `$HOME` replacement in the path, and the smaller issues (silenced git errors, `%` escaping, repos with no commits). What's left is mostly performance and cleanup.

## Performance

- **`zle reset-prompt` runs every `$(...)` in `PROMPT` again.** Because of `prompt_subst`, every time the PR job finishes (so on every Enter), git, docker and python all run a second time. The same happens on window resize.
- Each draw still starts many processes: about 6 subshells, 2 git calls, 2 `wc`, 2 `sed`, 2–3 `python` and 3 `docker` calls. The point above then doubles that.
- **Failed `gh` lookups aren't cached.** On `main` and on any branch with no PR, `gh pr view` calls the GitHub API on every prompt. (Non-git directories are now skipped.) Cache an empty result when the lookup fails.
- Every cache hit runs `jq` 4 times (lines 211–214). Use `gh ... --jq` to save a single ready-to-use line instead.
- Docker (lines 103–116): `docker info --format '{{.ContainersRunning}}/{{.Containers}}'` replaces your three calls with one. Add `(( $+commands[docker] )) || return` first. If the Docker daemon hangs, your prompt hangs too.
- Python's version and architecture don't change for a given `$VIRTUAL_ENV`, so cache them. Right now Python starts 2–3 times per prompt.
- Setting `pr_num=""` on every prompt (line 273) makes the PR section blink off and back on.

### Suggested structure

Work out each section in a `precmd` hook, store it in a variable, and make `PROMPT` a plain string of `${_jimple_*}` references. Then redrawing costs nothing. This is the biggest speed-up, but also the biggest change.

## Style and cleanup

- Line 1, `# !/usr/bin/env zsh`: the space makes it an ordinary comment, and the file is sourced anyway. Delete it.
- Colors are written two ways: `%{$fg[..]%}`/`$reset_color` and `%F{..}%f`. Pick `%F` and `%B` and drop `autoload colors`. `$fg_bold[grey]` is just `%B%F{black}`.
- Icons are stored as text like `'\uF179'` and only become symbols because `echo` converts escape codes:
  - `echo` will also mangle any backslash in a path or branch name.
  - `\U` reads up to 8 hex digits, so `\U2500` and `\UE73C` would swallow hex characters that follow them.

  Store them as `$'\uF179'` and print with `print -r --`. Also, `VCS_DIRTY_ICON` is a pasted symbol and the PR icons (lines 220–238) are hard-coded, so icons are defined three different ways.
- Unused code: `icon()`, `VCS_PR`, the OS icons, `_jimple_arch` (if you bring it back, use `$COLUMNS` instead of `tput cols`), and the `_prompt_async_start` wrapper (call `_jimple_gh_pr` from the hook directly).
- `P`, `NEWLINE`, `DELIM`, `icons`, `git_strings` and `pr_num` are generic global names that stay in your shell. Prefix them with `_jimple_`.
- `icons` is declared with `-gA` but `git_strings` with `-A`; make them match.
- `return $?` on line 292 returns the result of `[`, not git's. Use `|| return`.
- Mixed tabs and spaces: the PR `case` block (lines 216–244) and `_prompt_callback`/`_jimple_gh_pr` (lines 253–283) use spaces, and line 229 mixes both. The rest of the file uses tabs.
- Virtualenv section (lines 93–101):
  - `${VIRTUAL_ENV:t}` does the same as `basename` without starting a process.
  - Call `$VIRTUAL_ENV/bin/python` so you know you're getting the venv's Python.
  - Every project that uses a `.venv` folder shows up as `.venv`; `$VIRTUAL_ENV_PROMPT` gives a better name.

## What to fix first

1. Cache failed `gh` results so branches without a PR don't hit the API on every prompt.
2. Cache or collapse the docker and python calls.
3. Use `gh --jq` to drop the four `jq` calls.
4. The style cleanup (shebang, unused code, `return $?`, tabs).

Moving the sections into `precmd` is the biggest speed-up, but also the biggest change.
