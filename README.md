# Salar's Neovim Config

A focused Neovim setup for day-to-day coding, with fast navigation, LSP-backed editing, debugging, file browsing, and a theme workflow that is easy to switch without touching config files.

## Showcase

| Start screen | Code editing |
| --- | --- |
| ![Start screen](showcase/start_screen.png) | ![Code editing](showcase/code_editing.png) |

| File tree | Theme picker |
| --- | --- |
| ![File tree](showcase/file_tree.png) | ![Theme picker](showcase/color_theme_selection.png) |

## Highlights

- Plugin management through [lazy.nvim](https://github.com/folke/lazy.nvim), bootstrapped automatically on first launch.
- Fuzzy finding, live grep, references, implementations, and diagnostics through Telescope.
- LSP setup for TypeScript, C/C++, Lua, Rust, Typst, Haskell, GDScript, and Godot shader files.
- Completion with `nvim-cmp`, LuaSnip snippets, path suggestions, buffer words, and LSP sources.
- Treesitter highlighting for common web, systems, scripting, markdown, Haskell, and Godot filetypes.
- C/C++/Rust debugging through `nvim-dap`, with LLDB or CodeLLDB auto-detection.
- A custom theme picker with persisted selection and quick next/previous theme commands.
- Practical UI touches: file tree, bufferline, lualine, diagnostics, folds, markdown rendering, and quality-of-life editing plugins.

## Prerequisites

Before installing, make sure you have the following:

- **Neovim** >= 0.10
- **Git**
- **A C compiler** (`gcc` or `clang`) and `make` (needed for native plugin builds)
- **A Nerd Font** (for icons to render correctly)
- **[Material Icon Theme](https://github.com/odeking/material-icon-theme)** or any other icon theme for your desktop environment (for nvim-web-devicons to look correct in file pickers and nvim-tree)

### Ghostty Terminal (Recommended)

This config is designed to pair with the [Ghostty](https://ghostty.org/) terminal. To get the full experience with the background image, install Ghostty and copy the config:

```sh
# Install Ghostty (see https://ghostty.org/docs/install)
# On Arch:
paru -S ghostty-bin

# On Fedora:
# Follow https://ghostty.org/docs/install

# On Ubuntu/Debian (flatpak or build from source):
# See https://ghostty.org/docs/install

# Once Ghostty is installed, copy the config:
mkdir -p ~/.config/ghostty
cat > ~/.config/ghostty/config << 'EOF'
background-image = ~/.config/nvim/background/01-nvim_background.png
background-opacity = 1.0
window-decoration = none
EOF

# The background image is included in this repo under background/.
# The background path is already in .gitignore, so you need to copy it manually:
# Copy the background image from the cloned repo into the expected location
```

**Important:** The `background-image` path in the Ghostty config points to `~/.config/nvim/background/01-nvim_background.png`. The background image directory is excluded from git (see `.gitignore`), so you must supply your own background image at that path. Place any `.png` background image there after cloning.

## Install

Back up your existing config first, then clone this repo into Neovim's config directory:

```sh
# Back up existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone
git clone https://github.com/SalarAlo/neovim_configuration ~/.config/nvim
```

Then launch Neovim:

```sh
nvim
```

On first launch, `lazy.nvim` bootstraps itself and installs all configured plugins. This may take a minute.

### Language Servers

Mason will automatically install most language servers, but for the best experience install these system-wide:

```sh
# Arch Linux
sudo pacman -S nodejs npm lua-language-server rust-analyzer clang

# Fedora
sudo dnf install nodejs npm lua-language-server rust-analyzer clang

# Ubuntu/Debian
sudo apt install nodejs npm
# Then install language servers via Mason in Neovim (:Mason)
```

### Debugging (C/C++/Rust)

Install one of these DAP adapters:

```sh
# lldb-dap (preferred)
# Arch: sudo pacman -S lldb
# Fedora: sudo dnf install lldb
# Ubuntu: sudo apt install lldb

# Or codelldb via Mason
```

### Optional Tools

These improve the experience but are not required:

- **[lazygit](https://github.com/jesseduffield/lazygit)** - for `<leader>gg` git UI
- **[typst](https://typst.app/)** - for Typst document compilation
- **[zathura](https://github.com/pwmt/zathura)** - for Typst PDF preview
- **[gdshader-lsp](https://github.com/GodotShaderTools/gdshader-lsp)** - for Godot shader support
- **[gdscript-formatter](https://github.com/SalarAlo/gdscript-formatter)** - for GDScript formatting

## Keybindings

Leader is `<Space>`.

### Search & Navigation
| Key | Action |
| --- | --- |
| `<leader>ff` | Find files |
| `<leader>fw` | Live grep (basic) |
| `<leader>sg` | **Live grep with args** (ripgrep flags: `-g *.py`, `-t cpp`, pipes, etc.) |
| `<leader>fs` | Document symbols |
| `<leader>fc` | Search word under cursor |
| `<leader>fk` | Find keymaps |
| `<leader>sq` | Quickfix list |
| `<leader>sl` | Location list |
| `<leader>sr` | Registers |
| `<leader>sh` | Help tags |

### Telescope (inside picker)
| Key | Action |
| --- | --- |
| `<C-f>` | Quote prompt (for literal strings with spaces) |
| `<C-a>` | Quote prompt + `--hidden` flag |
| `<C-q>` | Send selection to quickfix |
| `<C-s>` | Send all results to quickfix |
| `<C-t>` | Open in Trouble |
| `<C-e>` | Fuzzy refine (filter results) |

### File Explorer
| Key | Action |
| --- | --- |
| `<C-n>` | Toggle file tree |
| `<leader>e` | Focus file tree |

### Buffer & Window Management
| Key | Action |
| --- | --- |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `<leader>x` | Close current buffer |
| `<leader>h` / `<leader>l` | Move buffer left / right |
| `<leader>sv` / `<leader>sh` | Split vertical / horizontal |
| `<leader>se` / `<leader>sx` | Equalize splits / Close split |

### LSP & Diagnostics
| Key | Action |
| --- | --- |
| `gd`, `gD`, `gi`, `gt` | LSP navigation (def, decl, impl, type) |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>d` / `<leader>D` | Line / buffer diagnostics |

### Debugger
| Key | Action |
| --- | --- |
| `<leader>dc` | Continue |
| `<leader>db` | Toggle breakpoint |
| `<leader>ds`, `<leader>di`, `<leader>do` | Step over / into / out |

### Inline Search & Replace (Spectre)
| Key | Action |
| --- | --- |
| `<leader>sr` | Toggle Spectre (search/replace UI) |
| `<leader>sw` | Spectre: Search word under cursor |
| `<leader>sp` | Spectre: Search in current file |
| `<leader>sS` | Send quickfix results to Spectre |

### Themes & Misc
| Key | Action |
| --- | --- |
| `<leader>ts` | Select theme |
| `<leader>tn` / `<leader>tp` | Next / previous theme |
| `<leader>tf` | Floating terminal |
| `<leader>tv` | Vertical terminal |
| `<leader>gg` | LazyGit |
| `<leader>bg` | Vim be good (motions trainer) |
| `<leader>lg` / `<leader>gc` | Open / clear the salar log |

## Logging

Configuration startup and plugin loads are logged to `~/.cache/nvim/salar.log` (or your `stdpath('cache')`).

- `:SalarLog` — open the log; `:SalarLog clear` clears it (also `<leader>lg` / `<leader>gc`)
- `:SalarLogLevel <trace|debug|info|warn|error>` — set log verbosity at runtime
- `vim.g.salar_log_level` / `vim.g.salar_log_enabled` — defaults (`info` / `true`)

## Structure

```text
init.lua                 Entry point
lua/salar/core/          Options, keymaps, theme state, filetype setup
lua/salar/plugins/       Plugin specs
lua/salar/plugins/lsp/   LSP and Mason setup
lua/salar/tools/         Small local helper tools (C++ utilities, Typst, skeleton)
background/              Background image for Ghostty terminal
showcase/                README screenshots
```
