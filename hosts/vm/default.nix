{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../system.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "vm"; # Define your hostname.

  # Configure console keymap
  console.keyMap = "fr";

  # Enable networking
  networking.networkmanager.enable = true;
}
