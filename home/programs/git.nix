{config, ...}:

{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
      };
    };
  
    userName = "Marius ANDRE";
    userEmail = "marius.andre@epita.fr";

    extraConfig = {
      color = {
        ui = "auto";
      };
    };

    ignores = [
      "*.com"
      "*.class"
      "*.dll"
      "*.exe"
      "*.o"
      "*.so"
      "*.swo"
      "*.log"
      ".DS_Store*"
      "ehthumbs.db"
      "Icon?"
      "Thumbs.db"
      "*.swp"
      " *~"
      "#*\#"
      ".\#*"
      ".vscode"
      ".gdb_history"
      ".ccls*/"
      ".idead"
      "__pycache__"
      "*.pyc"
      "env"
      ".pre-commit-config.yaml"
      "builddir"
      "result"
      "*.d"
      "*.o"
      "*.ko"
      "*.obj"
      "*.elf"
      "*.ilk"
      "*.map"
      "*.exp"
      "*.gch"
      "*.pch"
      "*.a"
      "*.la"
      "*.lo"
      "*.so"
      "*.so.*"
      "*.dylib"
      "*.exe"
      "*.out"
      "*.app"
      "*.i*86"
      "*.x86_64"
      "*.hex"
      "*.dSYM/"
      "*.su"
      "*.idb"
      "*.pdb"
      "*.mod*"
      "*.cmd"
      ".tmp_versions/"
      "modules.order"
      "Module.symvers"
      "Mkfile.old"
      "dkms.conf"
      ".pdf"
    ];
  };
}
