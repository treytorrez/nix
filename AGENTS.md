# Four Rules
- Simplicity
- Idomatic Design
- Declarative is best 
- Backup, backup, backup


## Related Tools

`update`

The `update` command is the way I update my system. It requires root to run so you shouuld check if you have root before you want to run it. It is defined by `./packages/git-autocommit.nix` but basically it keeps my system clean.
**NOTE** When using `update` if the build fails, *ALL CHANGES WILL BE STASHED* you will have to git stash pop to get them back. please check which stash you are popping before doing so.


Git

This whole thing is managed by a simple git set up that pushes after 5 commits. Please branch when adding a large new feature.

## Secrets

Secrets are managed with sops-nix. See **SECRETS.md** for the full workflow. Quick reference:
- `sops secrets/<name>.yaml` to edit
- `.sops.yaml` lists which age keys can decrypt
- Secret files in `secrets/` are encrypted and safe to commit
