## Terminal

- install guake. Dropdown terminal window: `sudo apt install guake`
- set theme for it. Dracula is most famous: Preferences -> Appearence -> choose Dracula
- install zsh command interpreter: `sudo apt install zsh`
- set zsh as default shell in guke preference to /usr/bin/zsh and for all system: `chsh -s $(which zsh)`
- install ohmyzsh: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` from https://github.com/ohmyzsh/ohmyzsh
- install ohmyzsh plugins: `cd ~/.oh-my-zsh/custom/plugins; git clone https://github.com/zsh-users/zsh-autosuggestions.git; git clone https://github.com/zsh-users/zsh-syntax-highlighting.git`
- add it plugins in ~/.zshrc:
`plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)`
- restart zsh: `source ~/.zshrc`
- download nerd font: `mkdir ~/.fonts && curl -fsL -o ~/.fonts/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip`
- unzip it: `unzip ~/.fonts/FiraCode.zip -d ~/.fonts/FiraCode && rm ~/.fonts/FiraCode.zip`
- recache fonts: `fc-cache -fv`
- install starship. Customazible prompt for shell: `curl -sS https://starship.rs/install.sh | sh` from https://github.com/starship/starship
- init starship, add this line to the end ~/.zshrc: `eval "$(starship init zsh)"`
- nerd fort preset for starship: `starship preset nerd-font-symbols -o ~/.config/starship.toml` from https://starship.rs/presets/nerd-font
- install markdown editor ghostwriter: `sudo apt install ghostwriter` from https://github.com/KDE/ghostwriter
- install tmux a terminal multiplexer: `sudo apt install tmux` from https://github.com/tmux/tmux. Tmux tutorial: https://www.linuxtrainingacademy.com/tmux-tutorial/
- add plugins https://hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/ see tmux section.
- install xclip for copy terminal text: `install xclip`
- ideas for disk encryption https://operavps.com/docs/encrypt-disk-ubuntu/


### Buttercup password manager

- install fuse: `sudo apt install libfuse2`
- download app image from https://buttercup.pw/
- move it to ~/Applications: `mv ~/Downloads/Buttercup-linux-x86_64.AppImage ~/Applications`
- set executable rigths: `chmod +x `~/Applications/Buttercup-linux-x86_64.AppImage`
- double click on it to mount
- the find the mount directory: `mount | grep -i buttercup`
- move icon from this directory to /home/YOU_HOME/.local/share/icons
- move buttercup.desktop to /home/YOU_HOME/.local/share/applications
- edit buttercup.desktop line with exec: Exec=/home/YOUR_HOME/Applications/Buttercup-linux-x86_64.AppImage --no-sandbox
- update desktop database: `update-desktop-database ~/.local/share/applications`

### TMUX

Tmux conf is stored under ~/.tmux.conf
It' s good idea to rebind the main prefix shortcut
`# remap prefix from 'C-b' to 'C-s'
unbind C-b
set-option -g prefix C-s
bind-key C-s send-prefix
`
Then lets reorder panes:
`# Start windows and panes index at 1, not 0.
set -g base-index 1
setw -g pane-base-index 1`
`#Ensure window index numbers get reordered on delete.
set-option -g renumber-windows on`

desight tweaks as in https://hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/

### Heroes
- install wine: `sudo apt install wine`

### VIM

vimtutor to practise the basics
installation: `sudo apt install neovim` but better to build from source https://github.com/neovim/neovim/blob/master/BUILD.md
https://thevaluable.dev/phpstorm-vs-vim/
https://thevaluable.dev/vim-php-ide/
https://alextheobold.com/posts/intelephense_in_neovim/

- install vim-plug from https://github.com/junegunn/vim-plug
- install git helper via vim-plug https://github.com/tpope/vim-fugitive
- install lsp zero via vim plug from https://github.com/VonHeikemen/lsp-zero.nvim
- install https://github.com/williamboman/mason.nvim
- install saadparwaiz1/cmp_luasnip
- install coffebar/transfer.nvim https://dev.to/saltaformajo/neovim-plugin-for-synchronization-with-remote-servers-4lal

you can edit nvim configuration file as `vi -c 'edit $MYVIMRC'`
to enable copy from/into nvim add `vim.api.nvim_set_option("clipboard", "unnamedplus")` to init.lua

phpactor as language server https://github.com/phpactor/phpactor
https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/phpactor.lua

netrw for custom keybindings https://github.com/prichrd/netrw.nvim

https://habr.com/ru/articles/149817/

intelephense docs https://www.npmjs.com/package/@yaegassy/coc-intelephense

keys https://lsp-zero.netlify.app/v3.x/language-server-configuration.html

### Tips
when open vpn fails: `sudo ip link delete tun0`

### Rsync
get list of changed files under git git ls-files --modified
rsync -R $(git ls-files --modified) /desitnation
sync of file save
look to netrw built-in file explorer https://vonheikemen.github.io/devlog/
all plugins suck, just need some lua scripting to set up autocommand:
`vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = {"*.php", "*.json"},
  callback = function()
      path = vim.api.nvim_buf_get_name(0)
      cur = vim.fn.getcwd()
      path = path:gsub(cur .. '/', '')
      code = string.format('rsync -R %s YOUR_HOST', path)
      vim.fn.jobstart(code)
  end
})`

### NODE JS
best way to install via nvm like here https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04

#### Resources
- https://askubuntu.com/questions/1311600/add-an-appimage-application-to-the-top-menu-bar
- https://linuxconfig.org/ubuntu-24-04-how-to-install-appimage
- https://github.com/buttercup/buttercup-desktop/issues/1355
- https://nickjanetakis.com/blog/start-your-tmuxt-window-and-pane-index-count-at-1-instead-of-0
- https://hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
