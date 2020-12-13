X_DIR = /home/athul/Workspace/expos/myexpos/xsm-progs
S_DIR = /home/athul/Workspace/expos/myexpos/spl-progs
E_DIR = /home/athul/Workspace/expos/myexpos/expl-progs

INT_SPL = $(wildcard $(S_DIR)/int*.spl)
INT_XSM = $(INT_SPL:$(S_DIR)/%.spl=$(X_DIR)/%.xsm)

MOD_SPL = $(wildcard $(S_DIR)/mod*.spl)
MOD_XSM = $(MOD_SPL:$(S_DIR)/%.spl=$(X_DIR)/%.xsm)

.PHONY: all xsm xfs clean interrupt modules user os

all: xfs

xfs: xsm
	echo "load --library ./bin/library.lib" >> commands_xfs
	xfs run commands_xfs
	rm commands_xfs

xsm: interrupt modules user os 

interrupt: $(INT_XSM) $(X_DIR)/timer.xsm $(X_DIR)/console.xsm $(X_DIR)/disk.xsm $(X_DIR)/exception.xsm

modules: $(MOD_XSM)

user: $(X_DIR)/shell.xsm 

os: $(X_DIR)/os.xsm $(X_DIR)/idle.xsm $(X_DIR)/login.xsm

$(X_DIR)/int%.xsm: $(S_DIR)/int%.spl
	spl $<
	echo "load --int=`echo $@ | tr -d -c 0-9` $@" >> commands_xfs

$(X_DIR)/mod%.xsm: $(S_DIR)/mod%.spl
	spl $<
	echo "load --module `echo $@ | tr -d -c 0-9` $@" >> commands_xfs

$(X_DIR)/os.xsm: $(S_DIR)/os.spl
	spl $<
	echo "load --os $@" >> commands_xfs

$(X_DIR)/shell.xsm: $(E_DIR)/shell.expl
	expl $<
	echo "load --shell $@" >> commands_xfs

$(X_DIR)/login.xsm: $(E_DIR)/login.expl
	expl $<
	echo "load --init $@" >> commands_xfs

$(X_DIR)/timer.xsm: $(S_DIR)/timer.spl
	spl $<
	echo "load --int=timer $@" >> commands_xfs

$(X_DIR)/disk.xsm: $(S_DIR)/disk.spl
	spl $<
	echo "load --int=disk $@" >> commands_xfs

$(X_DIR)/exception.xsm: $(S_DIR)/exception.spl
	spl $<
	echo "load --exhandler $@" >> commands_xfs

$(X_DIR)/console.xsm: $(S_DIR)/console.spl
	spl $<
	echo "load --int=console $@" >> commands_xfs

$(X_DIR)/idle.xsm: $(E_DIR)/idle.expl
	expl $<
	echo "load --idle $@" >> commands_xfs

clean: 
	echo "fdisk" >> commands_xfs
	xfs run commands_xfs
	rm commands_xfs
	rm $(X_DIR)/*.xsm
