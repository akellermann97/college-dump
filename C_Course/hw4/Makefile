#
# Created by gmakemake (Ubuntu Jul 25 2014) on Mon Oct  3 09:43:17 2016
#

#
# Definitions
#

.SUFFIXES:
.SUFFIXES:	.a .o .c .C .cpp .s .S
.c.o:
		$(COMPILE.c) $<
.C.o:
		$(COMPILE.cc) $<
.cpp.o:
		$(COMPILE.cc) $<
.S.s:
		$(CPP) -o $*.s $<
.s.o:
		$(COMPILE.cc) $<
.c.a:
		$(COMPILE.c) -o $% $<
		$(AR) $(ARFLAGS) $@ $%
		$(RM) $%
.C.a:
		$(COMPILE.cc) -o $% $<
		$(AR) $(ARFLAGS) $@ $%
		$(RM) $%
.cpp.a:
		$(COMPILE.cc) -o $% $<
		$(AR) $(ARFLAGS) $@ $%
		$(RM) $%

CC =		gcc
CXX =		g++

RM = rm -f
AR = ar
LINK.c = $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)
LINK.cc = $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)
COMPILE.c = $(CC) $(CFLAGS) $(CPPFLAGS) -c
COMPILE.cc = $(CXX) $(CXXFLAGS) $(CPPFLAGS) -c
CPP = $(CPP) $(CPPFLAGS)
########## Flags from header.mak

CC =     gcc
CFLAGS = -ggdb -std=c99 -Wall -Wextra -pedantic

########## End of flags from header.mak


CPP_FILES =	
C_FILES =	emp.c log.c mtime.c parse.c rpt.c song.c songtest.c
PS_FILES =	
S_FILES =	
H_FILES =	emp.h log.h mtime.h parse.h song.h
SOURCEFILES =	$(H_FILES) $(CPP_FILES) $(C_FILES) $(S_FILES)
.PRECIOUS:	$(SOURCEFILES)
OBJFILES =	emp.o log.o mtime.o parse.o song.o 

#
# Main targets
#

all: songtest rpt

songtest: songtest.o mtime.o song.o
	$(CC) $(CFLAGS) -o songtest  songtest.o mtime.o song.o $(CLIBFLAGS)

rpt: rpt.o emp.o log.o parse.o
	$(CC) $(CFLAGS) -o rpt  rpt.o emp.o log.o parse.o $(CLIBFLAGS)

#
# Dependencies
#

emp.o:	emp.h log.h parse.h
log.o:	emp.h log.h parse.h
mtime.o:	mtime.h
parse.o:	parse.h
rpt.o:	emp.h log.h
song.o:	mtime.h song.h
songtest.o:	mtime.h song.h

#
# Housekeeping
#

Archive:	archive.tgz

archive.tgz:	$(SOURCEFILES) Makefile
	tar cf - $(SOURCEFILES) Makefile | gzip > archive.tgz

clean:
	-/bin/rm -f $(OBJFILES) rpt.o songtest.o core

realclean:        clean
	-/bin/rm -f rpt songtest 
