{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };
  home = {
    username = "eino";
    homeDirectory = "/home/eino";
    keyboard.layout = "fi";
    packages = with pkgs; [ cowsay vim retroarch firefox icewm arandr pavucontrol sway wayfire mate.mate-terminal nix-prefetch-git sbcl lilypond libiconv openssl pkgconfig sqlite rustup gcc zathura audacity sox lmms];

    file.".emacs.d" = {
      recursive = true;
    	    source = pkgs.fetchFromGitHub {
	      owner = "eikrt";
	      repo = "emacs.d";
	      rev = "a294c15609cb52e3c88c37d93da5eeeb2b5150c3";
	      sha256 = "0ssy4wg4jvivnpx9jcg08gqpfaygxzwa2qf31i5n8yk60xlqz08m";
	    };
            #source = /home/eino/repo/.emacs.d;
  	};

  };
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        hs = "home-manager switch --flake .#eino@nixos";
        ns = "sudo nixos-rebuild switch --flake .#nixos";
        pfe = "nix-prefetch-git git@github.com:eikrt/emacs.d";
      };
      bashrcExtra = "export NIX_CONFIG='experimental-features = nix-command flakes'";
    };
    git = {
      enable = true;
      userName = "Eino Korte";
      userEmail = "e.i.korte@gmail.com";
    };
  };
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "mate-terminal"; 
      startup = [
      ];
      input = {"*" = {xkb_layout= "fi";}; }; 
    };
  };
  programs.waybar.enable = true;

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
