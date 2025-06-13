{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.boot.loader.refind;

  efi = config.boot.loader.efi;

refindBuilder = pkgs.writeShellScriptBin "install-refind" ''
  ${pkgs.python3}/bin/python3 ${./refind-builder.py} \
    --nix ${config.nix.package.out} \
    --timeout ${if config.boot.loader.timeout != null then toString config.boot.loader.timeout else "20"} \
    --max-entries ${toString cfg.maxGenerations} \
    ${optionalString (cfg.extraIcons != null) "--extra-icons ${toString cfg.extraIcons}"} \
    ${concatMapStringsSep " " (theme: "--theme ${toString theme}") cfg.themes} \
    --efi-mount ${efi.efiSysMountPoint} \
    ${if efi.canTouchEfiVariables then "--touch-vars" else ""}
'';


in {

  options.boot.loader.refind = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to enable the refind EFI boot manager";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration text appended to refind.conf";
    };

    maxGenerations = mkOption {
      type = types.int;
      default = 100;
      description = "Maximum number of generations in submenu. This is to avoid problems with refind or possible size problems with the config";
    };

    extraIcons = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "A directory containing icons to be copied to 'extra-icons'";
    };
    
    themes = mkOption {
      type = types.listOf types.path;
      default = [];
      description = "A list of theme paths to copy";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ refind gptfdisk findutils ];
    assertions = [
      {
        assertion = (config.boot.kernelPackages.kernel.features or { efiBootStub = true; }) ? efiBootStub;

        message = "This kernel does not support the EFI boot stub";
      }
    ];

    boot.loader.grub.enable = mkDefault false;

    # boot.loader.supportsInitrdSecrets = false; # TODO what does this do ?

    system = {
      build.installBootLoader = refindBuilder;

      boot.loader.id = "refind";

      requiredKernelConfig = with config.lib.kernelConfig; [
        (isYes "EFI_STUB")
      ];
    };
  };

}
