
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/system.nix
      ../../modules/kde.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-d27549bc-fed2-4404-98b1-f66688363cd6".device = "/dev/disk/by-uuid/d27549bc-fed2-4404-98b1-f66688363cd6";
  networking.hostName = "slave-1"; # Define your hostname.
  
  # Enable networking
  networking.networkmanager.enable = true;
}
