X_DIR = /home/athul/Workspace/expos/myexpos/xsm-progs
S_DIR = /home/athul/Workspace/expos/myexpos/spl-progs
E_DIR = /home/athul/Workspace/expos/myexpos/expl-progs

.PHONY: all xsm xfs clean interrupt modules user os

all: xfs

xfs: xsm
	xfs run commands_xfs
	rm commands_xfs

xsm: interrupt modules user os 

interrupt: $(X_DIR)/int9.xsm $(X_DIR)/int6.xsm $(X_DIR)/int7.xsm $(X_DIR)/int10.xsm $(X_DIR)/timer.xsm $(X_DIR)/console.xsm $(X_DIR)/disk.xsm

modules: $(X_DIR)/mod0.xsm $(X_DIR)/mod5.xsm $(X_DIR)/mod7.xsm $(X_DIR)/mod1.xsm $(X_DIR)/mod2.xsm $(X_DIR)/mod4.xsm

user: $(X_DIR)/init.xsm $(X_DIR)/idle.xsm

os: $(X_DIR)/os.xsm


$(X_DIR)/os.xsm: $(S_DIR)/os.spl
	spl $<
	echo "load --os $@" >> commands_xfs

$(X_DIR)/init.xsm: $(E_DIR)/init.expl
	expl $<
	echo "load --init $@" >> commands_xfs

$(X_DIR)/timer.xsm: $(S_DIR)/timer.spl
	spl $<
	echo "load --int=timer $@" >> commands_xfs

$(X_DIR)/disk.xsm: $(S_DIR)/disk.spl
	spl $<
	echo "load --int=disk $@" >> commands_xfs

$(X_DIR)/console.xsm: $(S_DIR)/console.spl
	spl $<
	echo "load --int=console $@" >> commands_xfs

$(X_DIR)/int6.xsm: $(S_DIR)/int6.spl
	spl $<
	echo "load --int=6 $@" >> commands_xfs
	
$(X_DIR)/int7.xsm: $(S_DIR)/int7.spl
	spl $<
	echo "load --int=7 $@" >> commands_xfs
	
$(X_DIR)/int9.xsm: $(S_DIR)/int9.spl
	spl $<
	echo "load --int=9 $@" >> commands_xfs

$(X_DIR)/int10.xsm: $(S_DIR)/int10.spl
	spl $<
	echo "load --int=10 $@" >> commands_xfs

$(X_DIR)/mod7.xsm: $(S_DIR)/mod7.spl
	spl $<
	echo "load --module 7 $@" >> commands_xfs

$(X_DIR)/mod4.xsm: $(S_DIR)/mod4.spl
	spl $<
	echo "load --module 4 $@" >> commands_xfs

$(X_DIR)/mod0.xsm: $(S_DIR)/mod0.spl
	spl $<
	echo "load --module 0 $@" >> commands_xfs

$(X_DIR)/mod5.xsm: $(S_DIR)/mod5.spl
	spl $<
	echo "load --module 5 $@" >> commands_xfs

$(X_DIR)/mod1.xsm: $(S_DIR)/mod1.spl
	spl $<
	echo "load --module 1 $@" >> commands_xfs

$(X_DIR)/mod2.xsm: $(S_DIR)/mod2.spl
	spl $<
	echo "load --module 2 $@" >> commands_xfs

$(X_DIR)/idle.xsm: $(E_DIR)/idle.expl
	expl $<
	echo "load --idle $@" >> commands_xfs

clean: $(X_DIR)/os.xsm $(X_DIR)/timer.xsm $(X_DIR)/idle.xsm
	rm $^
