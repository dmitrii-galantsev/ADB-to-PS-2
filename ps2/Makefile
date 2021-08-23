GHDL = ghdl
LIBS = ../include/cute_lib
LIBFLAGS = -P$(LIBS)
GHDLFLAGS = --std=08 -fsynopsys $(LIBFLAGS)
GHDLRUNFLAGS = --vcd=dump.vcd
VHDLFILES = $(wildcard *.vhdl)
VHDLFILES += $(wildcard test/*.vhdl)

include $(LIBS)/color.mk

all: run

libs: $(LIBS)
$(LIBS):
	$(MAKE) -C $@ libs

# Targets to analyze libraries
init: libs $(VHDLFILES)
	$(call print_green,"Compiling [$(VHDLFILES)] into [work]...")
	$(GHDL) -a $(GHDLFLAGS) $(VHDLFILES)
	$(call print_green_bld,"Compiling [$(VHDLFILES)] into [work] [DONE]")

# Run target
run: init
	$(call print_green,"Running testbench...")
	$(GHDL) -c $(GHDLFLAGS) -r testbench $(GHDLRUNFLAGS)
	$(call print_green_bld,"Running testbench [DONE]")

clean:
	$(GHDL) clean
	find ./ -iname "*.cf" -delete
	$(MAKE) -C $(LIBS) clean

.PHONY: all clean init run libs $(LIBS)
