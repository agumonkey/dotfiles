#!/bin/sh
# This came from Greg V's dotfiles:
#      https://github.com/myfreeweb/dotfiles
# Feel free to steal it, but attribution is nice
# Thanks:
#  https://cooltrainer.org/a-freebsd-desktop-howto/
#  https://github.com/pcbsd/freebsd/blob/master/etc/sysctl.conf

. common.sh

sysctl_set kern.ipc.shm_allow_removed=1 \
	kern.ipc.shmmax=67108864 \
	kern.ipc.shmall=32768 \
	kern.sched.preempt_thresh=224 \
	kern.maxfiles=200000 \
	kern.ipc.shm_allow_removed=1 \
	kern.shutdown.poweroff_delay=500 \
	vfs.usermount=1 \
	hw.snd.default_auto=1 \
	hw.usb.no_shutdown_wait=1 \
	net.inet6.ip6.use_tempaddr=1 \
	net.inet6.ip6.prefer_tempaddr=1 \
	net.inet.ip.fastforwarding=1 # NOTE: breaks IPSec

sysrc background_dhclient="YES" \
	syslogd_flags="-ss" \
	sendmail_enable="NONE" \
	smtpd_enable="YES" \

pkg install -y gmake-lite automake autoconf libidn libiconv gettext-runtime gettext-tools p5-Locale-gettext mime-support db5 cyrus-sasl gpgme

pkg info mutt >/dev/null || make BATCH=yes WITH="FLOCK GPGME ICONV IDN SASL MAILDIR_HEADER_CACHE NCURSES ASPELL" WITHOUT="XML DOCS EXAMPLES" -C /usr/ports/mail/mutt install clean
pkg lock -y mutt

pkg info opensmtpd >/dev/null || make BATCH=yes WITH="MAILERCONF" -C /usr/ports/mail/opensmtpd install clean
pkg lock -y opensmtpd
cat smtpd_desktop.conf > /usr/local/etc/mail/smtpd.conf

pkg install -y \
	ack ctags mercurial sloccount npm \
	urlview hashcash notmuch antiword w3m \
	py27-ranger py27-pip python35 rubygem-bundler \
	xorg compton unclutter xautolock slock bspwm sterm \
	zathura zathura-ps zathura-djvu zathura-pdf-poppler \
	feh dunst rofi xclip xsel maim slop pngquant xev redshift automount OpenSSH-askpass \
	xdotool xvkbd transset surf-browser meld gvolwheel \
	gnome-themes-standard qt5ct \
	fira noto paratype sourcecodepro-ttf sourcesanspro-ttf inconsolata-ttf fantasque-sans-mono \
	droid-fonts-ttf roboto-fonts-ttf comic-neue clearsans \

python3.5 -m ensurepip --upgrade --user

pkg info webfonts >/dev/null || make BATCH=yes WITH=MSWINDOWS_LICENSE -C /usr/ports/x11-fonts/webfonts install clean
pkg lock -y webfonts
