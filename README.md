# Dotfiles

个人使用的配置文件，包含 zsh、Powerlevel10k、AeroSpace、WezTerm、Windows Terminal 和 Oh My Posh。

仓库里的配置文件使用不带点的可见文件名，方便在编辑器和文件管理器里浏览。实际使用时，再把它们链接到各个程序在用户目录下需要读取的隐藏配置路径。

## 文件对应关系

| 配置 | 仓库文件 | macOS 链接目标 | Linux 链接目标 | Windows 链接目标 |
| --- | --- | --- | --- | --- |
| zsh | `zsh/zshrc` | `~/.zshrc` | `~/.zshrc` | 不适用 |
| Powerlevel10k | `zsh/p10k.zsh` | `~/.p10k.zsh` | `~/.p10k.zsh` | 不适用 |
| WezTerm | `wezterm/wezterm.lua` | `~/.wezterm.lua` | `~/.wezterm.lua` | 不适用 |
| AeroSpace | `AeroSpace/aerospace.toml` | `~/.aerospace.toml` | 不适用 | 不适用 |
| Windows Terminal | `WindowsTerminal/settings.json` | 不适用 | 不适用 | 手动配置 |
| Oh My Posh | `oh-my-posh/sixiaolong.omp.json` | 不适用 | 不适用 | `$HOME\sixiaolong.omp.json` |

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

## Windows

在仓库根目录执行：

```powershell
.\install-windows.ps1
```

如果创建符号链接失败，请用管理员权限运行 PowerShell，或在 Windows 设置里启用开发者模式。

这份 Windows Terminal 配置默认使用 PowerShell 7，并配置了 `MesloLGM Nerd Font`。Windows Terminal 的实际配置文件不由安装脚本链接，需要手动复制或维护。使用前建议确认已安装：

- PowerShell 7：`C:\Program Files\PowerShell\7\pwsh.exe`
- MesloLGM Nerd Font
- Oh My Posh：`oh-my-posh`

Windows 安装脚本会链接以下文件：

- `oh-my-posh/sixiaolong.omp.json` -> `$HOME\sixiaolong.omp.json`

PowerShell profile 可以手动加载本地 Oh My Posh 主题：

```powershell
oh-my-posh init pwsh --config "$HOME\sixiaolong.omp.json" | Invoke-Expression
```

## 备份已有配置

安装脚本会自动处理已有文件：

- 如果目标位置已经是符号链接，会直接更新链接。
- 如果目标位置是普通文件或目录，会先移动为 `*.before-dotfiles-时间戳` 备份文件，再创建新链接。

完成链接后，在这个仓库里修改配置文件，用户目录下对应的配置会同步生效。
