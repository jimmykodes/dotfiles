# Review: `zsh/themes/jimple/init.zsh`

_Originally reviewed at commit `a28da0f` (feat: lazy load pr number for prompt), 2026-11-25. Updated against the current state of the file to list only items that are still open._

All the bugs and nearly all the performance items are fixed. `PROMPT` is now a plain string of `${_jimple_s_*}` references filled in by a `precmd` hook, failed `gh` lookups are cached, `gh --jq` replaces the `jq` calls, docker is a single call, python info is cached per venv, and `pr_num` is only cleared when the repo or branch changes. The style cleanup is also done. What's left is a few small performance points.

## Performance

- **Docker timeout fallback (`_jimple_docker`).** If neither `timeout` nor `gtimeout` is installed (macOS has neither by default), `$tmo` is empty and a hung daemon hangs the prompt again. Either skip docker when no timeout command exists, or use a different way to bound it.
- **Docker still runs on every prompt.** The call is now one process, but it still talks to the daemon each time. Consider a short cache (a few seconds), or refresh it asynchronously like the PR section.
- **Leftover process starts in `precmd`.** Each prompt still forks 5 subshells for the section functions. It also runs git up to 3 times: `status` in `_jimple_git_branch`, `rev-parse` in `_jimple_gh_pr`, and `rev-parse` again inside `_jimple_get_pr_num` in the background job. The precmd hook could call the section functions directly and set the variables instead of using `$(...)`. The context for the PR job could also be passed in rather than recomputed.

## What to fix first

1. Make the docker call safe when no `timeout` command is available.
2. Optionally, cut the remaining subshells and duplicate git calls in `precmd`.
