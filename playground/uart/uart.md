# UART Module

## FT231X USB to serial UART

This is the chip used in the ULX3S FPGA board. These are the pins configured in the lpf file.

### ftdi_rxd

This is the TX from the FT231X, so this connects to the RX of the FPGA.

### ftdi_txd

This connects to the TX of the FPGA.

### ftdi_nrts

Request to Send Control Output / Handshake Signal. FPGA recieves.

### ftdi_ndtr

Data Terminal Ready Control Output / Handshake Signal. FPGA recieves.

### ftdi_txden

Enable transmit data for RS485 https://en.wikipedia.org/wiki/RS-485
