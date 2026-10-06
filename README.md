# dotfiles — `refrag/coder` branch

My setup for a Refrag [Coder](https://coder.refrag.gg) workspace (Ubuntu). `master` is the macOS setup.

Coder applies it on every workspace start: **Workspace → Settings → Parameters → Dotfiles URL**
`https://github.com/ssaunier/dotfiles.git`, branch `refrag/coder`. To apply by hand:

```sh
coder dotfiles -y https://github.com/ssaunier/dotfiles.git --branch refrag/coder
```

`install.sh` (idempotent):

- **zsh** as login shell: completion menu (case-insensitive, partial words), history search on ↑/↓,
  autosuggestions, syntax highlighting, fzf on Ctrl-R / Ctrl-T, a robbyrussell-style prompt. No framework.
- **git**: my identity and aliases (`git st`, `git co`, `git lg`, …) via `~/.config/git/config`.
  `~/.gitconfig` is never linked: the workspace writes a GitHub token into it.
- **vim** with a small `vimrc`.
- **Claude Code**: runs the team's [Refrag/dotfiles](https://github.com/Refrag/dotfiles) first, then merges
  `.claude/settings.json` (my `skillOverrides`) on top.

Public repo: nothing secret goes here.
