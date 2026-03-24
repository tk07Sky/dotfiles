# macos

macOS 向けの dotfiles セットアップ一式です。シンボリックリンクを使って設定ファイルをホームディレクトリに展開します。

## ディレクトリ構成

```
macos/
├── install.sh          # セットアップスクリプト
├── uninstall.sh        # アンインストールスクリプト
├── config/
│   ├── ghostty/
│   │   └── config      # Ghostty ターミナルエミュレータの設定
│   ├── homebrew/
│   │   └── Brewfile    # Homebrew でインストールするパッケージ一覧
│   ├── sheldon/
│   │   └── plugins.toml  # Sheldon (Zsh プラグインマネージャ) の設定
│   ├── starship.toml   # Starship プロンプトの設定
│   └── tmux/
│       └── tmux.conf   # tmux の設定
├── git/
│   └── gitconfig       # Git のグローバル設定
└── zsh/
    ├── zsh_alias       # エイリアス定義
    ├── zsh_functions   # 関数定義
    └── zsh_optrc       # Zsh のメイン設定ファイル (Homebrew / mise / Starship / Sheldon 等の初期化)
```

## セットアップ

```bash
cd macos
./install.sh
```

`install.sh` は以下を行います。

1. **Homebrew** が未インストールの場合、自動でインストールします。
2. 各設定ファイルをホームディレクトリへシンボリックリンクで展開します。
3. `Brewfile` を使って Homebrew パッケージを一括インストールします (`brew bundle`)。
4. `~/.zshrc` に `~/.zsh_optrc` を source する行を追記します。

既存のファイルがある場合は `~/.dotfiles_backup/<timestamp>/` にバックアップされます。

### リンク先の対応表

| ファイル                        | リンク先                              |
| ------------------------------- | ------------------------------------- |
| `config/starship.toml`          | `~/.config/starship.toml`             |
| `config/sheldon/plugins.toml`   | `~/.config/sheldon/plugins.toml`      |
| `config/tmux/tmux.conf`         | `~/.config/tmux/tmux.conf`            |
| `config/ghostty/config`         | `~/.config/ghostty/config`            |
| `git/gitconfig`                 | `~/.gitconfig`                        |
| `zsh/zsh_alias`                 | `~/.zsh_alias`                        |
| `zsh/zsh_functions`             | `~/.zsh_functions`                    |
| `zsh/zsh_optrc`                 | `~/.zsh_optrc`                        |

## アンインストール

```bash
cd macos
./uninstall.sh
```

`uninstall.sh` は `install.sh` が作成したシンボリックリンクを削除し、`~/.zshrc` に追記した source 行を取り除きます。管理外のファイルには触れません。

## 主なツール

| ツール | 用途 |
| --- | --- |
| [Homebrew](https://brew.sh/) | パッケージ管理 |
| [mise](https://mise.jdx.dev/) | ランタイムバージョン管理 |
| [Starship](https://starship.rs/) | シェルプロンプト |
| [Sheldon](https://sheldon.cli.rs/) | Zsh プラグインマネージャ |
| [tmux](https://github.com/tmux/tmux) | ターミナルマルチプレクサ |
| [Ghostty](https://ghostty.org/) | ターミナルエミュレータ |
