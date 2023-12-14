{config, pkgs, ...}:

{
  programs = {
    neovim.enable = true;

    vscode.enable = true;

    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-fugitive
        vim-addon-mw-utils
        tlib_vim
        vim-snipmate
        vim-snippets
        nerdtree
        nerdtree-git-plugin
        auto-pairs
        fzf-vim
        vim-airline
        vim-airline-themes
        ale
        ayu-vim
        vim-sensible
      ];
      extraConfig = ''
        let mapleader=" "
        set nocompatible
        filetype plugin on
        filetype plugin indent on
        syntax on
        set encoding=utf-8 fileencodings=
        set number relativenumber
        set signcolumn=yes
        set colorcolumn=80
        set noswapfile
        set incsearch
        set nohlsearch
        set tabstop=4
        set shiftwidth=4
        set expandtab
        set list
        set listchars=tab:⇒\ ,trail:•,extends:»,precedes:«
        autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
        map <leader>o :setlocal spell! spelllang=en <CR>
        map <leader>f gg=G
        set splitbelow splitright
        map <C-j> <C-w>h
        map <C-k> <C-w>j
        map <C-i> <C-w>k
        map <C-l> <C-w>l
        let g:vimwiki_ext2syntax={'.Rmd': 'markdown', '.rmd': 'markdown', '.md': 'markdown', '.markdown': "markdown", '.mdown': 'markdown'}
        autocmd BufRead,BufNewFile /tmp/calcurse*.,~/.calcurse/notes/* set filetype=markdown
        autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
        autocmd BufRead,BufNewFile *.tex set filetype=tex
        autocmd Filetype make setlocal noexpandtab
        map <leader>n :NERDTreeToggle<CR>
        nnoremap <silent> <s-f> :Files<CR>
        nnoremap <silent> <C-f> :Rg<CR>
        runtime! plugin/sensible.vim
        let g:airline_powerline_fonts = 1
        let g:snipMate = { 'snippet_version' : 1 }
                set t_Co=256
                set termguicolors
                let ayucolor="dark"
                colorscheme ayu
        let git_settings = system("git config --get vim.settings")
        if strlen(git_settings)
        	exe "set" git_settings
        endif

        fun! TrimWhitespace()
                let l:save = winsaveview()
                keeppatterns %s/\s\+$//e
                call winrestview(l:save)
        endfun

        fun! TrimEndLines()
            let save_cursor = getpos(".")
            silent! %s#\($\n\s*\)\+\%$##
            call setpos('.', save_cursor)
        endfunction

        augroup ANDRE
                autocmd!
                autocmd BufWritePre * :call TrimWhitespace()
                autocmd BufWritePre * :call TrimEndLines()
        augroup END_
      '';
    };
  };
}
