#!/bin/sh

# First wipes any TPM2 slots on the swap and disk partitions, and then enables
# them with the selected PCR registers, which protect against tamperproofing
# * PCR 0 - Core System Firmware executable code (aka Firmware)
# * PCR 2 - Extended or pluggable executable code 
# * PCR 7 - Secure Boot State

sudo systemd-cryptenroll /dev/nvme0n1p5 --wipe-slot=tpm2
sudo systemd-cryptenroll /dev/nvme0n1p6 --wipe-slot=tpm2
sudo systemd-cryptenroll /dev/nvme0n1p5 --tpm2-device=auto --tpm2-pcrs=0+2+7
sudo systemd-cryptenroll /dev/nvme0n1p6 --tpm2-device=auto --tpm2-pcrs=0+2+7

