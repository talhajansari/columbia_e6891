#
#  Makefile for SoundRuler
#
#  License: GPL
#  2007-04-02 Marcos Gridi-Papp <mgpapp@users.sourceforge.net>
#

NAME=soundruler
VERSION=0.9.6.1

PREFIX=/usr
DATADIR=${PREFIX}/share
MANDIR=${DATADIR}/man
GEN_PROFILE=${INSTROOT}/etc/profile

PKGDATADIR=${DATADIR}/${NAME}

install:
	mkdir -p ${INSTROOT}/usr/bin
	mkdir -p ${INSTROOT}${PKGDATADIR}
	mkdir -p ${INSTROOT}${DATADIR}/pixmaps
	mkdir -p ${INSTROOT}${DATADIR}/applications
	mkdir -p ${INSTROOT}${MANDIR}/man1
	mkdir -p ${INSTROOT}${MANDIR}/pt_BR/man1

	install -m 644 soundruler.1.gz ${INSTROOT}${MANDIR}/man1/soundruler.1.gz
	install -m 644 soundruler-pt_BR.1.gz ${INSTROOT}${MANDIR}/pt_BR/man1/soundruler.1.gz
	install -m 755 soundruler ${INSTROOT}${DATADIR}/${NAME}/soundruler
	perl -pi -e "s|/usr/local/share|${DATADIR}|g" soundruler.sh
	install -m 755 soundruler.sh ${INSTROOT}${PREFIX}/bin/soundruler
	ln -sf ${PREFIX}/bin/soundruler ${PREFIX}/bin/sruler
	install -m 644 README ${INSTROOT}${DATADIR}/${NAME}/.
	install -m 644 AUTHORS ${INSTROOT}${DATADIR}/${NAME}/.
	install -m 644 CHANGES ${INSTROOT}${DATADIR}/${NAME}/.
	install -m 644 COPYING ${INSTROOT}${DATADIR}/${NAME}/.
	install -m 644 KNOWN_BUGS ${INSTROOT}${DATADIR}/${NAME}/.
	install -m 644 SOURCES_WHERE ${INSTROOT}${DATADIR}/${NAME}/.
	install  -m 644 *.fig ${INSTROOT}${DATADIR}/${NAME}/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/colormaps
	install -m 664 filters/* ${INSTROOT}${DATADIR}/${NAME}/colormaps/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/filters
	install -m 664 filters/* ${INSTROOT}${DATADIR}/${NAME}/filters/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/icon
	install -m 644 icon/* ${INSTROOT}${DATADIR}/${NAME}/icon/.
	install -m 644 icon/soundruler.png ${INSTROOT}${DATADIR}/pixmaps/.
	install -m 644 icon/soundruler.desktop ${INSTROOT}${DATADIR}/applications/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/results
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/figures
	install -m 644 figures/* ${INSTROOT}${DATADIR}/${NAME}/figures/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/settings
	install -m 644 settings/* ${INSTROOT}${DATADIR}/${NAME}/settings/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/sounds
	install -m 644 sounds/* ${INSTROOT}${DATADIR}/${NAME}/sounds/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/help
	install -m 644 help/*.htm ${INSTROOT}${DATADIR}/${NAME}/help/.
	install -m 644 help/*.html ${INSTROOT}${DATADIR}/${NAME}/help/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/help/final
	install -m 664 help/final/* ${INSTROOT}${DATADIR}/${NAME}/help/final/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/bin
	install -m 755 bin/*.fig ${INSTROOT}${DATADIR}/${NAME}/bin/.
	install -m 755 bin/Matlab ${INSTROOT}${DATADIR}/${NAME}/bin/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/bin/glnx86
	install -m 755 bin/glnx86/* ${INSTROOT}${DATADIR}/${NAME}/bin/glnx86/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/datafun
	install -m 755 toolbox/matlab/datafun/* ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/datafun/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/datatypes
	install -m 755 toolbox/matlab/datatypes/* ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/datatypes/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/iofun
	install -m 755 toolbox/matlab/iofun/*.mexglx ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/iofun/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/iofun/private
	install -m 755 toolbox/matlab/iofun/private/* ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/iofun/private/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/ops
	install -m 755 toolbox/matlab/ops/* ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/ops/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/polyfun/private
	install -m 755 toolbox/matlab/polyfun/private/* ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/polyfun/private/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/sparfun
	install -m 755 toolbox/matlab/sparfun/* ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/sparfun/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/specfun
	install -m 755 toolbox/matlab/specfun/* ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/specfun/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/timefun
	install -m 755 toolbox/matlab/timefun/* ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/timefun/.
	install -d -m 755 ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/uitools
	install -m 755 toolbox/matlab/uitools/* ${INSTROOT}${DATADIR}/${NAME}/toolbox/matlab/uitools/.

clean:

