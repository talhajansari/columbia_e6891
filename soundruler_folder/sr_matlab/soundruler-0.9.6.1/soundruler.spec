Name            : soundruler
Version         : 0.9.6.1
Release		: 1%{?dist}
# If %{dist} is defined, insert its value here. If not, do nothing.
# See http://fedoraproject.org/wiki/DistTag

License         : GPL
Summary         : A tool for bioacoustic analysis, graphing and teaching.
Group           : Applications/Multimedia

URL             : http://soundruler.sourceforge.net
Vendor          : Marcos Gridi-Papp
Packager        : Marcos Gridi-Papp <mgpapp@users.sourceforge.net>

BuildRoot       : /var/tmp/%{name}-buildroot
Source          : soundruler-%{version}.linux.tar.gz

AutoReq         : No
AutoProv        : No

Requires        : bash, libXp

# Requires libXp.so.6, originally in XFree86-libs, which was removed from Fedora dist.
# Install libXp (FC5-6, from rpmfind.net) or xorg-x11-deprecated-libs (FC1-4) instead.

%define _unpackaged_files_terminate_build 0

%description

SoundRuler is a tool for acoustic analysis, graphing and teaching. 
It interactively recognizes and measures about 35 temporal and spectral 
properties of each pulse within each call in a file. It features acoustic similarity routines, real-time filtering, auditory filtering, graph batch production with extensive editing options, and didactic modules.

Install soundruler if you'd like to analyze or plot sounds,
or teach bioacoustics.

%prep
%setup -q

%build
#make

%install
make INSTROOT=$RPM_BUILD_ROOT install

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%docdir /usr/share/%{name}/help
/usr/share/%{name}/help

/usr/bin/soundruler
/usr/share/man/man1/soundruler.1.gz
/usr/share/man/pt_BR/man1/soundruler.1.gz

/usr/share/%{name}/about_win.fig
/usr/share/%{name}/bandpassgui_win.fig
/usr/share/%{name}/calibamplgui_win.fig
/usr/share/%{name}/ccagui_win.fig
/usr/share/%{name}/expeditgraphs_win.fig
/usr/share/%{name}/exportgraphs_win.fig
/usr/share/%{name}/FigureMenuBar.fig
/usr/share/%{name}/FigureToolBar.fig
/usr/share/%{name}/registration_win.fig
/usr/share/%{name}/setamplspect_win.fig
/usr/share/%{name}/setaudio_win.fig
/usr/share/%{name}/setautocorr_win.fig
/usr/share/%{name}/setcallmeas_win.fig
/usr/share/%{name}/setcallrecog_win.fig
/usr/share/%{name}/setcca_win.fig
/usr/share/%{name}/setcepstrum_win.fig
/usr/share/%{name}/setclickplot_win.fig
/usr/share/%{name}/setfftspect_win.fig
/usr/share/%{name}/setgeneral_win.fig
/usr/share/%{name}/setlog_win.fig
/usr/share/%{name}/setprint_win.fig
/usr/share/%{name}/setpulse_win.fig
/usr/share/%{name}/setsave_win.fig
/usr/share/%{name}/setspect_win.fig
/usr/share/%{name}/setzoomoscil_win.fig
/usr/share/%{name}/soundmath_win.fig
/usr/share/%{name}/sruler1024x768_win.fig
/usr/share/%{name}/sruler800x600_win.fig
/usr/share/%{name}/textpad_win.fig
/usr/share/%{name}/tuning_win.fig

#   /usr/share/soundruler/setmodspect_win.fig
#   /usr/share/soundruler/setmtsd_win.fig
#   /usr/share/soundruler/setunix_win.fig
#   /usr/share/soundruler/templateguisetts.fig

/usr/share/%{name}/colormaps
/usr/share/%{name}/filters
/usr/share/%{name}/figures
/usr/share/%{name}/results
/usr/share/%{name}/settings
/usr/share/%{name}/sounds
/usr/share/%{name}/icon
/usr/share/%{name}/bin
/usr/share/%{name}/toolbox
/usr/share/%{name}/soundruler
/usr/share/pixmaps/soundruler.png
/usr/share/applications/soundruler.desktop
/usr/share/%{name}/AUTHORS
/usr/share/%{name}/CHANGES
/usr/share/%{name}/COPYING
/usr/share/%{name}/KNOWN_BUGS
/usr/share/%{name}/README
/usr/share/%{name}/SOURCES_WHERE


%changelog
* Mon Mar 12 2007 Marcos Gridi-Papp <mgpapp@users.sourceforge.net> 
- updated file list for new release
* Fri Aug 06 2004 Marcos Gridi-Papp <mgpapp@users.sourceforge.net> 
- first rpm
