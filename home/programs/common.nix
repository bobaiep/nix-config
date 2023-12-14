{config, pkgs, ...}:

{
  home.packages = with pkgs; [
    zip
    unzip
    p7zip

    # utils
    ripgrep
    htop
    openssl
    xclip
    tree
    neofetch

    # programming
    nodejs
    nodePackages.npm
    python3
    virtualenv
    gnumake
    gcc
    gdb
    docker-compose

    discord
  ];

  programs = {
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "Monokai Extended";
      };
    };
    btop.enable = true;
    ssh.enable = true;
    thunderbird = {
      enable = true;
      profiles.boba.isDefault = true;
    };
  };
}
