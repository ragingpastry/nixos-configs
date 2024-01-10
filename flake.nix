{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:mic92/sops-nix";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awsvpnclient.url = "github:ymatsiuk/awsvpnclient?rev=8bdfd42d893f7e80c5d0044cdb3181bdf3612ff2";
    arc.url = "github:arcnmx/nixexprs";
    gomod2nix = {
      url = "github:tweag/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix  = { url = "github:musnix/musnix"; };

  };

  outputs = { self, nixpkgs, home-manager, nixos-generators, awsvpnclient, gomod2nix, arc, ... }@inputs:
    let
      inherit (nixpkgs.lib) filterAttrs;
      inherit (builtins) mapAttrs elem;
      inherit (self) outputs;
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    rec {

      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays;

      nixosConfigurations = rec {
        # Desktop
        conjoiner = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./machines/conjoiner ];
        };
        # Work Laptop
        polis = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./machines/polis inputs.musnix.nixosModules.musnix ];
        };
        # Personal Laptop
        pattern-juggler = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./machines/pattern-juggler ];
        };
        # VPS
        konishi = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./machines/konishi ];
        };

        # VPS 2
        carter-zimmerman = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./machines/carter-zimmerman ];
        };

        # Landon's laptop
        markedmoose = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./machines/markedmoose ];
        };

      };

      homeConfigurations = {
        # Desktop
        "crepe@conjoiner" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/crepe/conjoiner.nix ];
          overlay = import ./overlays;
        };

        # Work Laptop
        "crepe@polis" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/crepe/polis.nix ];
          overlay = import ./overlays;
        };

        # Personal Laptop
        "crepe@pattern-juggler" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/crepe/pattern-juggler.nix ];
          overlay = import ./overlays;
        };

        # VPS
        "crepe@konishi" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/crepe/konishi.nix ];
        };

        # VPS 2
        "crepe@carter-zimmerman" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/crepe/carter-zimmerman.nix ];
        };

        # Landon's laptop
        "crepe@markedmoose" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/crepe/markedmoose.nix ];
        };

        "landon@markedmoose" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/landon/markedmoose.nix ];
        };




      };

    };
}
