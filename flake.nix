{
  description = "NixOS Unstable Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote"; # Lanza unstable
      inputs.nixpkgs.follows = "nixpkgs";
    };

    scroll-flake = {
      url = "github:AsahiRocks/scroll-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    custom-pkgs = {
      url = "github:redzrush101/custom-nix-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      llm-agents,
      ...
    }@inputs:
    let
      overlay-llm-agents = final: prev: {
        llm-agents = inputs.llm-agents.packages.x86_64-linux;
      };
      overlay-iflow = final: prev: {
        iflow-cli = inputs.custom-pkgs.packages.x86_64-linux.iflow-cli;
      };
      overlay-iloader = final: prev: {
        iloader = inputs.custom-pkgs.packages.x86_64-linux.iloader;
      };
      overlay-mtkclient = final: prev: {
        mtkclient = inputs.custom-pkgs.packages.x86_64-linux.mtkclient;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos/default.nix
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nixos-hardware.nixosModules.gigabyte-b550
          home-manager.nixosModules.home-manager
          ./modules/nixos/services/iloader.nix
          {
            nixpkgs.overlays = [
              overlay-llm-agents
              overlay-iflow
              overlay-iloader
              overlay-mtkclient
              inputs.nix-cachyos-kernel.overlays.default
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yassin = import ./home/yassin/default.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

      packages.x86_64-linux =
        {
          inherit (inputs.llm-agents.packages.x86_64-linux) opencode claude-code-router droid;
          inherit (inputs.custom-pkgs.packages.x86_64-linux) iflow-cli iloader mtkclient;
        };
    };
}
