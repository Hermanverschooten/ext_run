# Variables to override
# #
# # CC            C compiler
# # CROSSCOMPILEcrosscompiler prefix, if any
# # CFLAGScompiler flags for compiling all C files
# # ERL_CFLAGSadditional compiler flags for files using Erlang header files
# # ERL_EI_LIBDIR path to libei.a
# # LDFLAGSlinker flags for linking all binaries
# # ERL_LDFLAGSadditional linker flags for projects referencing Erlang libraries
#
# # Look for the EI library and header files
# # For crosscompiled builds, ERL_EI_INCLUDE_DIR and ERL_EI_LIBDIR must be
# # passed into the Makefile.
ifeq ($(ERL_EI_INCLUDE_DIR),)
	ERL_ROOT_DIR = $(shell erl -eval "io:format(\"~s~n\", [code:root_dir()])" -s init stop -noshell)
	ifeq ($(ERL_ROOT_DIR),)
		$(error Could not find the Erlang installation. Check to see that 'erl' is in your PATH)
	endif
	ERL_EI_INCLUDE_DIR = "$(ERL_ROOT_DIR)/usr/include"
	ERL_EI_LIBDIR = "$(ERL_ROOT_DIR)/usr/lib"
endif

 #    # Set Erlang-specific compile and linker flags
 ERL_CFLAGS ?= -I$(ERL_EI_INCLUDE_DIR)
 ERL_LDFLAGS ?= -L$(ERL_EI_LIBDIR)

LDFLAGS += -fPIC -shared  -dynamiclib
CFLAGS ?= -fPIC -O2 -Wall -Wextra -Wno-unused-parameter
CC ?= $(CROSSCOMPILER)gcc

ifeq ($(CROSSCOMPILE),)
	ifeq ($(shell uname),Darwin)
		LDFLAGS += -undefined dynamic_lookup
	endif
endif

.PHONY: all clean

all: priv/ext_run_nif.so

%.o: %.c
	$(CC) -c $(ERL_CFLAGS) $(CFLAGS) -o $@ $<

priv/ext_run_nif.so: src/ext_run_nif.o
	@mkdir -p priv
	$(CC) $^ $(ERL_LDFLAGS) $(LDFLAGS) -o $@

clean:
	rm -f priv/ext_run_nif.so src/*.o
