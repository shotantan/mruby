# makefile discription.
# basic build file for mruby library (Ruby part)

# project-specific macros
# extension of the executable-file is modifiable(.exe .out ...)
BASEDIR = .
TARGET := mrblib
MLIB := $(TARGET).o
CLIB := $(TARGET).c
DLIB := $(TARGET).ctmp
RLIB := $(TARGET).rbtmp
DEPLIB := $(TARGET).d
MRB1 := $(BASEDIR)/*.rb
MRBS := $(MRB1)
LIBR0 := ../lib/libmruby_core.a
LIBR := ../lib/libmruby.a

# libraries, includes
INCLUDES = -I../src -I../include

ifeq ($(strip $(COMPILE_MODE)),)
  # default compile option
  COMPILE_MODE = debug
endif

# ifeq ($(COMPILE_MODE),debug)
#   CFLAGS = -g -O3
# else ifeq ($(COMPILE_MODE),release)
#   CFLAGS = -O3
# else ifeq ($(COMPILE_MODE),small)
#   CFLAGS = -Os
# endif

CFLAGS=-MD -mcpu=cortex-m4 
#-march=armv7e-m -mtune=cortex-m4
# -march=armv7e-m -mtune=cortex-m3
CFLAGS+=-g -Os -mapcs-frame -mno-sched-prolog -std=gnu99 -gdwarf-2 -fno-strict-aliasing -fsigned-char -ffunction-sections -fdata-sections -fno-schedule-insns2 --param max-inline-insns-single=1000 -fno-common -fno-hosted -mfloat-abi=softfp -mfpu=fpv4-sp-d16 -mlittle-endian -mthumb -flto-partition=none -fipa-sra -lnostdlib
AFLAGS  = -mcpu=cortex-m4 -mthumb -mthumb-interwork -mlittle-endian -mfloat-abi=softfp -mfpu=fpv4-sp-d16
CFLAGS  = -mcpu=cortex-m4 -mthumb -mthumb-interwork -mlittle-endian -mfloat-abi=softfp -mfpu=fpv4-sp-d16 -O2 \


ALL_CFLAGS =  $(CFLAGS)
ifeq ($(OS),Windows_NT)
  MAKE_FLAGS = CC=$(CC) LL=$(LL) ALL_CFLAGS="$(ALL_CFLAGS)"
else
  MAKE_FLAGS = CC='$(CC)' LL='$(LL)' ALL_CFLAGS='$(ALL_CFLAGS)'
endif

# mruby compiler
# ifeq ($(OS),Windows_NT)
# MRBC = ../bin/mrbc.exe
# else
# MRBC = ../bin/mrbc
# endif
MRBC = mrbc

##############################
# generic build targets, rules

.PHONY : all
all : $(LIBR)

# update libmruby.a
$(LIBR) : $(MLIB) $(LIBR0)
	$(CP) $(LIBR0) $(LIBR)
	$(AR) r $(LIBR) $(MLIB)

# Compile mrblib source
$(MLIB) : $(CLIB)
	$(CC) $(ALL_CFLAGS) -MMD $(INCLUDES) -c $(CLIB) -o $(MLIB)

# Compile C source from merged mruby source
$(CLIB) : $(RLIB)# $(MRBC)
	$(MRBC) -Bmrblib_irep -o$(DLIB) $(RLIB); $(CAT) init_$(TARGET).c $(DLIB) > $@

$(MRBC) : ../src/opcode.h ../src/codegen.c ../src/parse.y
	$(MAKE) -C ../tools/mrbc $(MAKE_FLAGS)

# merge mruby sources
$(RLIB) : $(MRBS)
	$(CAT) $(MRBS) > $@

# clean up
.PHONY : clean
clean :
	@echo "make: removing targets, objects and depend files of `pwd`"
	-$(RM_F) $(MRBC) $(MLIB) $(CLIB) $(RLIB) $(DLIB) $(DEPLIB) $(LIBR)
