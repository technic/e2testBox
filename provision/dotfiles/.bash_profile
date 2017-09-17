echo "> Have fun!"
force_color_prompt=yes
test -d $HOME/bin && export PATH=$HOME/bin:$PATH
test -n "$XDG_VTNR" && test $XDG_VTNR -eq 1 && startx
test -f ~/.bashrc && . ~/.bashrc
