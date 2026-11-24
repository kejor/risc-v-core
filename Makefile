BUILD_DIR := ./build
BLINK_DIR := ./playground/blink
ULX3S_LPF_PATH := ./ulx3s/ulx3s_v20.lpf

.PHONY: blink
blink: $(BLINK_DIR)/blink.bit
	mv -f $(BLINK_DIR)/blink.bit $(BUILD_DIR)/ulx3s.bit

$(BLINK_DIR)/blink.json: $(BLINK_DIR)/blink.sv
	echo "read_verilog $(BLINK_DIR)/blink.sv\nsynth_ecp5 -json $(BLINK_DIR)/blink.json" >> $(BLINK_DIR)/blink.ys
	docker run --rm --mount type=bind,src=$(CURDIR),dst=/workspace yosys-oss-cad-suite:latest \
		/bin/bash -c "yosys /workspace/playground/blink/blink.ys"

$(BLINK_DIR)/blink.config: $(BLINK_DIR)/blink.json
	docker run --rm --mount type=bind,src=$(CURDIR),dst=/workspace yosys-oss-cad-suite:latest \
		/bin/bash -c "nextpnr-ecp5 --85k --json /workspace/playground/blink/blink.json --lpf /workspace/ulx3s/ulx3s_v20.lpf --textcfg /workspace/playground/blink/blink.config"

$(BLINK_DIR)/blink.bit: $(BLINK_DIR)/blink.config
	docker run --rm --mount type=bind,src=$(CURDIR),dst=/workspace yosys-oss-cad-suite:latest \
		/bin/bash -c "ecppack /workspace/playground/blink/blink.config /workspace/playground/blink/blink.bit"

prog: $(BUILD_DIR)/ulx3s.bit
	openFPGALoader -b ulx3s $(BUILD_DIR)/ulx3s.bit
