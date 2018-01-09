
# Generic Makefile to compile a collection of pd-pure objects to a shared
# library which can be loaded with Pd's -lib option.

# Package name and version:
dist = raptor-$(version)
version = 5.2

# Platform-specific stuff. Only Linux and Mac OS X have been tested and are
# known to work. On Linux you'll need pure-avahi, pure-bonjour on the Mac.
# A Windows port should be feasible as well, using the Bonjour module,
# but this hasn't been tried yet and surely needs some work.

# The filename extension for Pd object libraries depends on your operating
# system. Edit this as needed.
PDEXT       = .pd_linux

# Other platform-specific information can be obtained from Pure's pkg-config.
DLL         = $(shell pkg-config pure --variable DLL)
PIC         = $(shell pkg-config pure --variable PIC)
shared      = $(shell pkg-config pure --variable shared)
purelib     = $(shell pkg-config pure --variable libdir)/pure

pure_incl   = $(shell pkg-config pure --cflags)
pure_libs   = $(shell pkg-config pure --libs)

# Compilation and linker flags. Adjust these as needed.
CFLAGS = -g -O2
ALL_CFLAGS = $(PIC) $(CFLAGS) $(CPPFLAGS) -I. $(pure_incl) -I$(pdincdir) -Ipd
ALL_LDFLAGS = $(LDFLAGS) $(pure_libs) $(LIBS)

# Pd flavour (e.g., pd, pd-extended, pd-l2ork, etc.). Pd and Pd-Extended are
# known to work on both Linux and Mac OS X; on Linux Pd-L2Ork works, too.
PD=pd

# Pd executable name variants.
PDEXE=$(subst pd-extended,pdextended,$(PD))

# Try to guess the Pd installation prefix:
prefix = $(patsubst %/bin/$(PDEXE),%,$(shell which $(PDEXE) 2>/dev/null))
ifeq ($(strip $(prefix)),)
# Fall back to /usr/local.
prefix = /usr/local
endif

# Installation goes into $(libdir)/$(PD), you can also set this directly
# instead of $(prefix).
libdir = $(prefix)/lib
includedir = $(prefix)/include

# Pd library path.
pdlibdir = $(libdir)/$(PD)

# Install dir for the externals and accompanying stuff.
pdextradir = $(pdlibdir)/extra/raptor

# Specific setup for the various Pd flavours.
ifeq ($(PD),pd-l2ork)
PD_INC=/pdl2ork
endif
ifeq ($(PD),pd-extended)
PD_INC=/pdextended
endif

# Pd include path. This is searched for m_pd.h if we have it. Otherwise the
# generic header file pd/m_pd.h in the sources is used. This enables us to
# compile pd-pure on systems where Pd isn't installed in the usual places
# (most importantly, Mac and Windows).
pdincdir = $(includedir)$(PD_INC)

# Helper libraries.
solibs      = pdstub$(DLL)

ifeq ($(DLL),.dylib)
# OSX doesn't have -rpath, thus we need to hardcode some path into our helper
# libraries so that the Apple dyld can find them at runtime.
dllname = -install_name "@loader_path/$@"
# We also need to adjust the module suffix.
PDEXT = .pd_darwin
endif

%$(DLL): %.c
	gcc $(shared) $(dllname) $(ALL_CFLAGS) $< -o $@ $(ALL_LDFLAGS)

all: $(solibs) raptor$(PDEXT) raptor-meta.pd

raptor-meta.pd: raptor-meta.pd.in Makefile
	sed -e "s?@version@?$(version)?g" < $< > $@

check = $(wildcard $(purelib)/$(1)$(DLL))

ifeq ($(DLL),.dylib)
# OS X: We need the -undefined dynamic_lookup linker flag here to link back
# into the Pd executable.
extralibs = -Wl,-undefined -Wl,dynamic_lookup
endif

# This links the compiled Pure code and loader to a shared library object with
# the proper extension required by Pd.
raptor$(PDEXT): raptor.o loader.o
	gcc $(PIC) $(shared) $^ $(extralibs) -o raptor$(DLL)
	test "$(DLL)" = "$(PDEXT)" || mv raptor$(DLL) raptor$(PDEXT)

# This uses the Pure interpreter to compile our pd-pure objects to native code.
# Note that the --main option is necessary to prevent name clashes and allow
# the module to coexist with other modules of its kind.
raptor.o: raptor.pure mksym.pure symchange.pure mkmeter.pure splitmeter.pure mktuplet.pure oscfilter.pure ms2ticks.pure ticks2ms.pure
	pure $(PIC) -c $^ -o $@ --main=__raptor_main__

# Compile a minimal loader module which is needed to interface to Pd and
# register the object classes with pd-pure.
loader.o: loader.c
	gcc $(PIC) $(pure_incl) -Ipd -c $< -o $@

clean:
	rm -Rf *.o *$(DLL)* *$(PDEXT)
