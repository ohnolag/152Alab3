TOP=top
PART=xc7a35tcpg236-1
DEVICE=xc7a35tcpg236-1
XDC=v/constraints.xdc
BUILD=build
SOURCES=v/clocks.v v/debouncer.v v/fsm.v v/segDisplay.v v/toplevel.v

all: $(BUILD)/$(TOP).bit

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/$(TOP).json: $(SOURCES) | $(BUILD)
	yosys -p "read_verilog $(SOURCES); synth_xilinx -flatten -abc9 -arch xc7 -top $(TOP); write_json $@"

$(BUILD)/$(TOP).fasm: $(BUILD)/$(TOP).json $(XDC)
	nextpnr-xilinx --chipdb chipdb/$(DEVICE).bin --xdc $(XDC) --json $< --write $(BUILD)/$(TOP)_routed.json --fasm $@

$(BUILD)/$(TOP).frames: $(BUILD)/$(TOP).fasm
	python3 /opt/prjxray/utils/fasm2frames.py --part $(PART) --db-root /opt/openxc7/lib/external/prjxray-db/artix7 $< > $@

$(BUILD)/$(TOP).bit: $(BUILD)/$(TOP).frames
	xc7frames2bit --part_file /opt/openxc7/lib/external/prjxray-db/artix7/$(PART)/part.yaml --part_name $(PART) --frm_file $< --output_file $@

clean:
	rm -rf $(BUILD)
