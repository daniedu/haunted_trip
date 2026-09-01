# Git Recovery — After `.devenv` History Purge

History was rewritten on `2026-08-31` to **permanently remove `.devenv/` and `haunted_trip` binary from all commits** (previously tracked 9 commits of `.devenv`, 2 of `haunted_trip`).
Local `main` was set to `fd600f8` and force-pushed to `origin/main`. Other clones will now be **diverged** (`ahead 13, behind 16` style).

`.gitignore:1` now permanently ignores `.devenv/` (`git status --ignored` shows `!! .devenv/`), `git ls-files` only tracks `devenv.lock/.nix/.yaml`.

## If your other computer says `diverged` or still tracks `.devenv`

### Option A — Keep folder, hard-reset (recommended if you have no local unpushed work)

```bash
# 1. save any local work you need
git stash push -m "backup-before-reset" --include-untracked
git status
git log --oneline --all --graph -10  # confirm you're behind/diverged

# 2. fetch the rewritten history
git fetch origin

# 3. reset local main to origin/main
git checkout main
git reset --hard origin/main

# 4. clean any leftover cached .devenv (if it still shows in `git ls-files | grep "^\.devenv"`)
git rm -r --cached .devenv 2>/dev/null || true
git status --ignored   # should show !! .devenv/  and  !! haunted_trip  only as ignored, not tracked
git ls-files | grep -E "^\.devenv|haunted_trip"  # should be empty except devenv.lock/nix/yaml
git log --all --oneline --full-history -- ".devenv"  # should be empty
```

### Option B — Fresh clone (simplest, loses no history)

```bash
cd /tmp
git clone git@github.com:daniedu/haunted_trip.git
# or: gh repo clone daniedu/haunted_trip
cd haunted_trip
git status --ignored
```

### If you had local commits not yet pushed

```bash
git fetch origin
git log origin/main..HEAD --oneline  # your local-only commits
git format-patch origin/main --stdout > /tmp/my-patches.patch  # save them
git reset --hard origin/main
# re-apply:
git cherry-pick <commit-hash>  # or: git apply /tmp/my-patches.patch
```

### Verify fix

```bash
git ls-files | grep devenv   # expect only: devenv.lock, devenv.nix, devenv.yaml
git check-ignore -v .devenv/nix-eval-cache.db  # expect: .gitignore:1:.devenv/
git log --all --oneline --full-history -- ".devenv"  # expect: (no output)
du -sh .git  # should be ~300-600K, not 1.3M
```

### Why force-push was needed

`git filter-repo --invert-paths --path .devenv --path haunted_trip` rewrites every commit hash. Normal `git pull` would create a merge of old+new history. Hard-reset is required once.

Keep `.gitignore` entry `.devenv/` — never `git add -f .devenv/`.
