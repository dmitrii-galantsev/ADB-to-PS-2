GHDL = ghdl
LIBS = ../include/cute_lib
LIBFLAGS = -P$(LIBS)
GHDLFLAGS = --std=08 $(LIBFLAGS)
GHDLRUNFLAGS =

include $(LIBS)/color.mk

all: elab

libs: $(LIBS)
$(LIBS):
	$(MAKE) -C $@

# Targets to analyze libraries
init: libs
	$(GHDL) -a $(GHDLFLAGS) ps2.vhdl
	$(GHDL) -a $(GHDLFLAGS) tb_ps2.vhdl

# Elaborate target.  Almost useless
elab: init
	$(GHDL) -c $(GHDLFLAGS) -e ps2_master
	$(GHDL) -c $(GHDLFLAGS) -e testbench

# Run target
run: init
	#$(GHDL) -c $(GHDLFLAGS) -r ps2_master $(GHDLRUNFLAGS)
	$(GHDL) -c $(GHDLFLAGS) -r testbench $(GHDLRUNFLAGS)

clean:
	$(GHDL) clean
	find ../ -iname "*.cf" -delete

.PHONY: clean all init elab run libs $(LIBS)
