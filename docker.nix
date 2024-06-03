# THIS DOCKER IMAGE CONFIGURATION IS JUST FOR TESTING PURPOSES NOT FOR PRODUCTION USE
{ inputs, nixosModules, system }:

(inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ({ config, ... }: {
      imports = [
        (inputs.nixpkgs + "/nixos/modules/virtualisation/docker-image.nix")
        nixosModules.polkadot-validator
      ];

      # On a real system root would either not get a password at all or it
      # would be configured using hashedPassword.
      # For the Docker image this is good enough :)
      users.users.root.password = "yolo";
      services.getty.autologinUser = "root";

      # Enabling flakes in docker
      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      # Validator configuration
      dotnix.polkadot-validator.enable = true;
      dotnix.polkadot-validator.enableLoadCredentialWorkaround = true;
      dotnix.polkadot-validator.name = "dotnix-docker";
      dotnix.polkadot-validator.chain = "westend";
      dotnix.polkadot-validator.extraArgs = [
        "--db-storage-threshold=0"
      ];

      environment.systemPackages = [
        config.dotnix.polkadot-validator.package
      ];
    })
  ];
}).config.system.build.tarball
