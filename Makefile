DIRS = c_stuff po server

PREFIX = /usr/local
DATADIR = $(PREFIX)/share
LIBDIR = $(PREFIX)/lib
BINDIR = $(PREFIX)/bin
MANDIR = $(DATADIR)/man

all: prepare dirs

prepare:
	perl -ne "print \$$1 if m|\\\$$version = '(.*)';|" c_stuff/lib/fb_stuff.pm > VERSION

dirs:
	@if ! perl -e 'use SDL'; then echo -e "\n    *** I need perl-SDL installed"; false; fi
	@if ! perl -e 'use SDL; ($$mj, $$mn, $$mc) = split /\./, $$SDL::VERSION; exit 1 if $$mj<1 || $$mn<19'; then echo -e "\n    *** I need perl-SDL version 1.19.0 or upper"; false; fi
	@for n in . $(DIRS); do \
		[ "$$n" = "." ] || $(MAKE) -C $$n ;\
	done
	@if [ ! -d save_virgin ]; then mkdir save_virgin; cp c_stuff/lib/fb_stuff.pm save_virgin; fi
	cp -f save_virgin/fb_stuff.pm c_stuff/lib/fb_stuff.pm
	perl -pi -e 's|\@DATADIR\@|$(DATADIR)|' c_stuff/lib/fb_stuff.pm
	perl -pi -e 's|\@LIBDIR\@|$(LIBDIR)|' c_stuff/lib/fb_stuff.pm


install: $(ALL)
	@for n in $(DIRS); do \
		(cd $$n; $(MAKE) install DESTDIR=$(DESTDIR)) \
	done
	install -d $(BINDIR)
	install frozen-bubble frozen-bubble-editor $(BINDIR)
	install -d $(DATADIR)/frozen-bubble
	cp -a gfx snd data $(DATADIR)/frozen-bubble
	rm -f $(DATADIR)/frozen-bubble/gfx/shoot/create.pl
	install -d $(LIBDIR)/frozen-bubble
	install server/fb-server $(LIBDIR)/frozen-bubble
	install -d $(MANDIR)/man6
	install doc/*.6 $(MANDIR)/man6

clean: 
	@for n in $(DIRS); do \
		(cd $$n; $(MAKE) clean) \
	done
	@if [ -d save_virgin ]; then cp -f save_virgin/fb_stuff.pm c_stuff/lib/fb_stuff.pm; rm -rf save_virgin; fi

