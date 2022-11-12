" formatting
" tabs => 4 spaces
:set expandtab
:set shiftwidth=4
:set smartindent

" tui
:set number relativenumber
:set colorcolumn=100

" plugins
call plug#begin('~/.config/nvim/plugged')

" UI improvements
Plug 'itchyny/lightline.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

" theming
Plug 'morhetz/gruvbox'
" Plug 'chriskempson/base16-vim'
Plug 'shinchu/lightline-gruvbox.vim'

" easier file finding
Plug 'airblade/vim-rooter'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" tree-sitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'IndianBoy42/tree-sitter-just'

call plug#end()

" setup theming 
autocmd vimenter * ++nested colorscheme gruvbox
" colorscheme base16-default-dark

" simple setups
lua << END

require('gitsigns').setup()
-- require('tree-sitter-just').setup() -- this requires an arg

END


" lightline setup
let g:lightline = {
\   'active': {
\     'left': [
\       ['mode', 'paste'],
\       ['readonly', 'filename', 'modified']
\     ],
\     'right': [
\       ['lineinfo'],
\       ['percent'],
\       ['fileencoding', 'filetype']
\     ],
\   },
\   'component_function' : {
\     'filename': 'LightlineFilename'
\   },
\   'colorscheme': 'gruvbox'
\ }

function! LightlineFilename()
        return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction


if executable('rg')
    set grepprg=rg\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif
