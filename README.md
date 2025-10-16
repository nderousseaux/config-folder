# My configuration

This the folder which configure my dev environment on my mac.

`install.sh` is the script to install all the configuration.

## Script overview 
The script does the following:
- Update all configurations files with colors defined in `colors.json`.
- Install xcode command line tools if not installed.
- Install `homebrew` if not installed.
- Install and configure `hyper` terminal.
- Install and configure `zsh` shell with `oh-my-zsh`.
- Configure `ssh` client.
- Install and configure `git`.
- Install and configure `vim` editor.
- Install and configure `tmux` terminal multiplexer.

## Git config

### Git aliases

- **yolo**: Commit staged changes with a random message from [whatthecommit.com](https://whatthecommit.com).
- **install-hooks**: Copy Git hooks from `$HOME/.config/git/template/hooks` to the current repo, set permissions, and confirm.
- **work-email**: Set Git user email to work address (`n.derousseaux@unistra.fr`).
- **perso-email**: Set Git user email to personal address (`n.derousseaux@icloud.com`).

### Commit category
Here are the commit categories and their prefixes:

- **📦 base:** Base setup and initial configuration.
- **✨ feat:** New features or functionality.
- **🎨 design:** UI/UX and design changes.
- **🐛 fix:** Bug fixes.
- **🧪 test:** Adding or updating tests.
- **🏗️ build:** Build system or dependencies.
- **🧱 struct:** Project structure changes.
- **📚 doc:** Documentation updates.
- **🔧 internal:** Internal changes and maintenance.
- **⚡️ perf:** Performance improvements.
- **🚜 refactor:** Code refactoring.
- **✏️ typo:** Typo corrections.
- **🚧 wip:** WIP commits.
- **📝 meta:** Meta changes (e.g., README, changelog).
- **⚙️ config:** Configuration changes.

Use these prefixes at the start of your commit messages to categorize changes.
An emoji will be automatically added based on the prefix.
