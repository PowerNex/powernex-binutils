FROM base/archlinux-dlang
MAINTAINER Dan Printzell <me@vild.io>

RUN pacman -Syyu texinfo python guile2.0 ncurses expat xz --noprogressbar --noconfirm
