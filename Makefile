X_DIR = /home/athul/Workspace/expos/myexpos/xsm-progs
S_DIR = /home/athul/Workspace/expos/myexpos/spl-progs
E_DIR = /home/athul/Workspace/expos/myexpos/expl-progs

.PHONY: all xsm xfs clean

all: xfs

xfs: xsm
	xfs run commands_xfs
	rm commands_xfs

xsm: $(X_DIR)/os.xsm $(X_DIR)/timer.xsm $(X_DIR)/idle.xsm 

$(X_DIR)/os.xsm: $(S_DIR)/os.spl
	spl $<
	echo "load --os $@" >> commands_xfs

$(X_DIR)/init.xsm: $(S_DIR)/init.spl
	spl $<
	echo "load --init $@" >> commands_xfs

$(X_DIR)/timer.xsm: $(S_DIR)/timer.spl
	spl $<
	echo "load --int=timer $@" >> commands_xfs

$(X_DIR)/idle.xsm: $(E_DIR)/idle.expl
	expl $<
	echo "load --idle $@" >> commands_xfs

clean: $(X_DIR)/os.xsm $(X_DIR)/timer.xsm $(X_DIR)/idle.xsm
	rm $^
