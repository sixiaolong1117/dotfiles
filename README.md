# Dotfiles

个人使用的配置文件，包含 zsh、Powerlevel10k、AeroSpace 和 WezTerm。

仓库里的配置文件使用不带点的可见文件名，方便在编辑器和文件管理器里浏览。实际使用时，再把它们链接到各个程序在用户目录下需要读取的隐藏配置路径。

## 文件对应关系

| 配置 | 仓库文件 | macOS 链接目标 | Linux 链接目标 |
| --- | --- | --- | --- |
| zsh | `zsh/zshrc` | `~/.zshrc` | `~/.zshrc` |
| Powerlevel10k | `zsh/p10k.zsh` | `~/.p10k.zsh` | `~/.p10k.zsh` |
| WezTerm | `wezterm/wezterm.lua` | `~/.wezterm.lua` | `~/.wezterm.lua` |
| AeroSpace | `AeroSpace/aerospace.toml` | `~/.aerospace.toml` | 不适用 |

## macOS

在仓库根目录执行：

```sh
./install-macos.sh
```

## Linux

在仓库根目录执行：

```sh
./install-linux.sh
```

AeroSpace 是 macOS 窗口管理器，所以 `AeroSpace/aerospace.toml` 在 Linux 下不需要链接。

## 备份已有配置

安装脚本会自动处理已有文件：

- 如果目标位置已经是符号链接，会直接更新链接。
- 如果目标位置是普通文件或目录，会先移动为 `*.before-dotfiles-时间戳` 备份文件，再创建新链接。

完成链接后，在这个仓库里修改配置文件，用户目录下对应的配置会同步生效。
