````markdown
# yazi-cwd

Zsh plugin to open [Yazi](https://github.com/sxyazi/yazi) and automatically `cd` into the last directory when you exit.

## Features

- Launch Yazi and sync your shell to the directory you quit in.
- Default command: `y`
- Configurable via environment variables:
  - `YAZI_BIN` → path to Yazi binary (default: auto-detected in `$PATH`)
  - `YAZI_FUNC` → function name to expose (default: `y`)
- Lightweight, no dependencies other than Yazi itself.
- Includes simple tab completion for directories.
- Plays nicely with [zoxide](https://github.com/ajeetdsouza/zoxide).

## Installation

### [Antidote](https://getantidote.github.io)
```zsh
antidote load El3ssar/zsh-yazi-cwd
````

### [Zinit](https://github.com/zdharma-continuum/zinit)

```zsh
zinit light El3ssar/zsh-yazi-cwd
```

### Manual

Clone and source:

```zsh
git clone https://github.com/El3ssar/zsh-yazi-cwd.git ~/.zsh/yazi-cwd
source ~/.zsh/yazi-cwd/yazi-cwd.plugin.zsh
```

## Usage

Simply run:

```zsh
y
```

This opens Yazi. When you exit, your shell will automatically `cd` into the directory you left Yazi in.

### Customization

In your `~/.zshrc`:

```zsh
# Use a different binary
export YAZI_BIN=/usr/local/bin/yazi

# Change function name
export YAZI_FUNC=yz
```

Now you can launch Yazi with `yz` instead of `y`.

## Example

```zsh
~/projects » y
# inside yazi: navigate to ~/Downloads, then quit
~/Downloads »
```

## License

MIT

```
```

