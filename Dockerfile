FROM archlinux/base
MAINTAINER Dan Printzell <me@vild.io>

RUN pacman -Syu --noconfirm dmd dtools dub ldc git tar xz base-devel texinfo python guile2.0 ncurses expat
