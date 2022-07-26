" include .zsh-theme in zsh highlighting scheme
if exists("did_load_filetypes")
	finish
endif
augroup filetypedetect
	au! BufRead,BufNewFile *.zsh-theme	setfiletype zsh
augroup END
