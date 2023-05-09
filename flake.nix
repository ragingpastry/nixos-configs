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

    awsvpnclient.url = "github:ymatsiuk/awsvpnclient";
    arc.url = "github:arcnmx/nixexprs";
    gomod2nix = {
      url = "github:tweag/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, nixos-generators, awsvpnclient, gomod2nix, arc, ... }@inputs:
    let
      inherit (nixpkgs.lib) filterAttrs;
      inherit (builtins) mapAttrs elem;
      inherit (self) outputs;
      supportedSystems = [ "x86_64-linux" ];
      nixpkgsFor = forAllSystems (system: import nixpkgs
        { inherit system; overlays = [ gomod2nix.overlays.default ]; }
      );
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    rec {

      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays;

      pkgs = import nixpkgs {
        overlays = [
          gomod2nix.overlays.default
        ];
      };

      packages = forAllSystems (
        system: let
          pkgs = nixpkgsFor.${system};
        in {
          nixwarp = pkgs.buildGoApplication {
            pname = "nixwarp";
            version = "0.1.1";
            src = ./cli.;
            modules = ./cli/gomod2nix.toml;
          };
          default = nixpkgsFor.${system}.nixwarp;
        }
      );
      #defaultPackage = packages.${nixpkgs.lib.currentSystem}.nixwarp;
      #defaultPackage = forAllSystems (system: self.packages."${system}".nixwarp);
      #packages = forAllSystems
      #  (system:
      #    import ./pkgs {
      #      pkgs = nixpkgs.legacyPackages.${system};
      #    }
      #  );
      #devShells = forAllSystems (system: {
      #  default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix { };
      #});

      nixosConfigurations = rec {
        # Desktop
        conjoiner = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./machines/conjoiner ];
        };
        # Work Laptop
        polis = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./machines/polis ];
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
      };

    };
}
