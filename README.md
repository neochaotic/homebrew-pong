# homebrew-pong

Homebrew Cask tap for [Pong](https://github.com/neochaotic/pong) — a menu-bar companion for
people who live inside Claude.ai all day.

## Install

```bash
brew install neochaotic/pong/pong
```

or tap first, then install:

```bash
brew tap neochaotic/pong
brew install --cask pong
```

If Homebrew's tap-trust check blocks this (`Refusing to load cask ... from untrusted tap`), run
`brew trust neochaotic/pong` first.

## Why this exists

Pong's builds aren't code-signed or notarized yet (that needs a paid Apple Developer account —
see the [main repo's README](https://github.com/neochaotic/pong#install)), so a plain `.dmg`
double-click hits a Gatekeeper warning on first launch. This Cask's `postflight` strips the
quarantine flag automatically and launches the app, so `brew install` just works end to end — no
right-click, no Terminal command, no scary "is damaged" dialog, and no wondering whether anything
happened (Pong has no Dock icon or window, so without the auto-launch a successful install and a
silently-failed one would look identical).

Its `uninstall quit:` stanza also terminates any running Pong before `install`/`upgrade`/`uninstall`
replaces the app, so an update can never leave an old process running underneath a new binary.

## Updating the Cask for a new Pong release

Bump `version` and both `sha256` values (arm and intel) in [`Casks/pong.rb`](Casks/pong.rb) to
match the new release's `.dmg` assets, then:

```bash
brew style --fix Casks/pong.rb
brew audit --cask pong   # after `brew tap neochaotic/pong <this checkout>` locally
```
