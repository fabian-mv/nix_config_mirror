{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.apps.neovim;
in {
  options.local.apps.neovim = {
    enable = mkEnableOption "Neovim settings";
  };
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;

      extraConfig = ''
        set nobackup
        set showmatch               " show matching
        set hlsearch                " highlight search
        set incsearch               " incremental search
        set tabstop=4               " number of columns occupied by a tab
        set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
        set shiftwidth=4            " width for autoindents
        set autoindent              " indent a new line the same amount as the line just typed
        set number                  " add line numbers
        set wildmode=longest,list   " get bash-like tab completions
        set cc=80                   " set an 80 column border for good coding style
        filetype plugin indent on   " allow auto-indenting depending on file type
        syntax on                   " syntax highlighting
        set mouse=a                 " enable mouse click
        set clipboard=unnamedplus   " using system clipboard
        filetype plugin on
        set cursorline              " highlight current cursorline
        set ttyfast                 " Speed up scrolling in Vim
        set noswapfile              " disable creating swap file
      '';

      plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-multiple-cursors
      ];
    };
  };
}
