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
      overlay-openspec = final: prev: {
        openspec = inputs.custom-pkgs.packages.x86_64-linux.openspec;
      };
      overlay-odin = final: prev: {
        odin4 = final.callPackage ./pkgs/odin4 { };
      };

      # Shared logic common to all hosts
      shared-modules = [
        inputs.lanzaboote.nixosModules.lanzaboote
        home-manager.nixosModules.home-manager
        ./modules/nixos/iloader.nix
        {
          nixpkgs.overlays = [
            overlay-llm-agents
            overlay-iflow
            overlay-iloader
            overlay-mtkclient
            overlay-openspec
            overlay-odin
            inputs.nix-cachyos-kernel.overlays.default
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.yassin = import ./home/yassin/default.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];

    in
    {
      nixosConfigurations = {
        # DESKTOP CONFIGURATION
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/desktop/default.nix
            inputs.nixos-hardware.nixosModules.gigabyte-b550
          ] ++ shared-modules;
        };

        # LAPTOP CONFIGURATION
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/laptop/default.nix
          ] ++ shared-modules;
        };
      };

      packages.x86_64-linux =
        {
          inherit (inputs.llm-agents.packages.x86_64-linux) claude-code-router droid opencode openspec;
          inherit (inputs.custom-pkgs.packages.x86_64-linux) iflow-cli iloader mtkclient;
          odin4 = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/odin4 { };
        };
    };
}
