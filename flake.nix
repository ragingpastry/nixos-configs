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

  };

  outputs = { self, nixpkgs, home-manager, nixos-generators, awsvpnclient, ... }@inputs:
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


      #packages.x86_64-linux = {
      #  carter-zimmerman-kexec = nixos-generators.nixosGenerate {
      #    system = "x86_64-linux";
      #    modules = [
      #      ./machines/carter-zimmerman
      #    ];
      #    format = "kexec-bundle";
      #  };
      #};
      packages = forAllSystems
        (system: {
          carter-zimmerman-kexec = nixos-generators.nixosGenerate {
            system = system;
            modules = [
              ./machines/carter-zimmerman
            ];
            format = "kexec-bundle";
          };
        });
      #packages = forAllSystems
      #  (system:
      #    import ./pkgs {
      #      pkgs = nixpkgs.legacyPackages.${system};
      #    }
      #  );
      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix { };
      });

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
