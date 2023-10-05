#!/bin/bash

# Load the necessary kernel modules
modprobe libcomposite
modprobe configfs
modprobe usb_f_hid

# Define variables for the USB gadget configuration
GADGET_DIR="/sys/kernel/config/usb_gadget/myhid"
REPORT_DESCRIPTOR="/path/to/your/report_descriptor"  # Replace with your HID report descriptor file
UDC="g1"  # Replace with the appropriate UDC (USB Device Controller)

# Create the USB gadget configuration
mkdir "$GADGET_DIR"
echo "0x1d6b" > "$GADGET_DIR/idVendor"
echo "0x0104" > "$GADGET_DIR/idProduct"
mkdir "$GADGET_DIR/strings/0x409"
echo "My HID Gadget" > "$GADGET_DIR/strings/0x409/manufacturer"
echo "HID Device" > "$GADGET_DIR/strings/0x409/product"
mkdir "$GADGET_DIR/functions/hid.usb0"
echo 1 > "$GADGET_DIR/functions/hid.usb0/protocol"
echo 1 > "$GADGET_DIR/functions/hid.usb0/subclass"
echo 8 > "$GADGET_DIR/functions/hid.usb0/report_length"
cp "$REPORT_DESCRIPTOR" "$GADGET_DIR/functions/hid.usb0/report_desc"

# Create the gadget configuration and bind the HID function
mkdir "$GADGET_DIR/configs/c.1"
mkdir "$GADGET_DIR/configs/c.1/strings/0x409"
echo "Config 1: HID Gadget" > "$GADGET_DIR/configs/c.1/strings/0x409/configuration"
ln -s "$GADGET_DIR/functions/hid.usb0" "$GADGET_DIR/configs/c.1"

# Enable the gadget and bind it to the specified UDC
mkdir "$GADGET_DIR/UDC"
echo "$UDC" > "$GADGET_DIR/UDC"

echo "HID Gadget setup complete."
