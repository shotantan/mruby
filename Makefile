# makefile discription.
# basic build file for mruby

# compiler, linker (gcc), archiver, parser generator
export CC = arm-none-eabi-gcc
export LL = arm-none-eabi-gcc
export AR = arm-none-eabi-ar
export YACC = bison

ifeq ($(strip $(COMPILE_MODE)),)
  # default compile option
  COMPILE_MODE = release
endif

# ifeq ($(COMPILE_MODE),debug)
#   CFLAGS = -g -O3 -mcpu=cortex-m4 -mthumb
# else ifeq ($(COMPILE_MODE),release)
# #  OPTIMIZATION = s -fno-schedule-insns2 -fsection-anchors -fpromote-loop-indices -ffunction-sections -fdata-sections
# #  CFLAGS = -Wall -mcpu=cortex-m3 -mfloat-abi=softfp -mthumb -mfix-cortex-m3-ldrd -O$(OPTIMIZATION) -static -lm
# #  CFLAGS += -D__RAM_MODE__=0 -DHAVE_STRING_H=1
#   CFLAGS=-Wall #-Wno-array-bounds 
#   CFLAGS=-MD -mcpu=cortex-m4 -march=armv7e-m -mtune=cortex-m4
#   CFLAGS+=-g -O2 -mlittle-endian -mthumb
#   CFLAGS+=-mfloat-abi=softfp -mapcs-frame -mno-sched-prolog
#   CFLAGS+=-std=gnu99 -gdwarf-2 -fno-strict-aliasing -fsigned-char -ffunction-sections
#   CFLAGS+=-fdata-sections -fno-schedule-insns2 --param max-inline-insns-single=1000
#   CFLAGS+=-fno-common -fno-hosted -u g_pfnVectors #-Wl,-static -Wl,--gc-sections
#   CFLAGS+=-nostartfiles -mfpu=fpv4-sp-d16 -flto-partition=none -fipa-sra -DHAVE_STRING_H=1 #-lm -lc -LGcc
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
  MAKE_FLAGS = --no-print-directory CC=$(CC) LL=$(LL) ALL_CFLAGS='$(ALL_CFLAGS)'
else
  MAKE_FLAGS = --no-print-directory CC='$(CC)' LL='$(LL)' ALL_CFLAGS='$(ALL_CFLAGS)'
endif

##############################
# internal variables

export MSG_BEGIN = @for line in
export MSG_END = ; do echo "$$line"; done

export CP := cp
export RM_F := rm -f
export CAT := cat

##############################
# generic build targets, rules

.PHONY : all
all :
	@$(MAKE) -C src $(MAKE_FLAGS)
	@$(MAKE) -C mrblib $(MAKE_FLAGS)
#	@$(MAKE) -C tools/mruby $(MAKE_FLAGS)
#	@$(MAKE) -C tools/mirb $(MAKE_FLAGS)

# mruby test
.PHONY : test
test : all
	@$(MAKE) -C test $(MAKE_FLAGS)

# clean up
.PHONY : clean
clean :
	@$(MAKE) clean -C src $(MAKE_FLAGS)
	@$(MAKE) clean -C tools/mruby $(MAKE_FLAGS)
	@$(MAKE) clean -C tools/mirb $(MAKE_FLAGS)
	@$(MAKE) clean -C test $(MAKE_FLAGS)

# display help for build configuration and interesting targets
.PHONY : showconfig
showconfig :
	$(MSG_BEGIN) \
	"" \
	"  CC = $(CC)" \
	"  LL = $(LL)" \
	"  MAKE = $(MAKE)" \
	"" \
	"  CFLAGS = $(CFLAGS)" \
	"  ALL_CFLAGS = $(ALL_CFLAGS)" \
	$(MSG_END)

.PHONY : help
help :
	$(MSG_BEGIN) \
	"" \
	"            Basic mruby Makefile" \
	"" \
	"targets:" \
	"  all (default):  build all targets, install (locally) in-repo" \
	"  clean:          clean all built and in-repo installed artifacts" \
	"  showconfig:     show build config summary" \
	"  test:           run all mruby tests" \
	$(MSG_END)
