setxkbmap -option "terminate:ctrl_alt_bksp"
test -f ~/.Xresourses && xrdb -merge -I$HOME ~/.Xresourses
VBoxClient --clipboard
exec openbox-session
