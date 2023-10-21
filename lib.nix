_: lib: let
  # Filesystem related functions
  fs = rec {
    /*
    Function: collectNixFiles
    Synopsis: Recursively collects `.nix` files from a directory into an attribute set.

    Parameters:
      - dirPath (string): The directory path to collect `.nix` files from.

    Returns:
      - An attribute set mapping filenames (without the `.nix` suffix) to their paths.
    */
    collectNixFiles = dirPath: let
      isNixOrDir = file: type: (type == "regular" && lib.hasSuffix ".nix" file) || (type == "directory");
      collect = file: type: {
        name = lib.removeSuffix ".nix" file;
        value = let
          path = dirPath + "/${file}";
        in
          if (type == "regular") || (type == "directory" && builtins.pathExists (path + "/default.nix"))
          then path
          else collectNixFiles path;
      };
      files = lib.filterAttrs isNixOrDir (builtins.readDir dirPath);
    in
      lib.filterAttrs (_: v: v != {}) (lib.mapAttrs' collect files);
  };

  # Flake related functions
  flakes = {
    /*
    Function: mkApp
    Synopsis: Creates an "app" type for Nix flakes.

    Parameters:
      - drv (derivation): The Nix derivation.
      - name (string, optional): Name of the application.
      - exePath (string, optional): Executable path.

    Returns:
      - An "app" type attribute with 'type' and 'program' keys.
    */
    mkApp = {
      drv,
      name ? drv.pname or drv.name,
      exePath ? drv.passthru.exePath or "/bin/${name}",
    }: {
      type = "app";
      program = "${drv}${exePath}";
    };

    filterPkgs = path: by: let
      path' =
        if builtins.isList path
        then path
        else (lib.splitString "." path);
    in
      lib.filterAttrs (_: pkg: by == (lib.attrByPath path' "" pkg));
  };

  # Nix related functions
  nix = {
    /*
    Function: mkNixpkgs
    Synopsis: Creates a custom Nixpkgs configuration.

    Parameters:
      - system (string): Target system, e.g., "x86_64-linux".
      - inputs (attrset, optional): Custom inputs for the Nixpkgs configuration.
      - overlays (list, optional): List of overlays to apply.
      - nixpkgs (path, optional): Path to the Nixpkgs repository. Defaults to inputs.nixpkgs.
      - config (attrset, optional): Additional Nixpkgs configuration settings.

    Returns:
      - A configured Nixpkgs environment suitable for importing.

    Example:
      mkNixpkgs {
        system = "x86_64-linux";
        overlays = [ myOverlay ];
      }

    Description:
      The function imports a Nixpkgs environment with the specified target system, custom inputs,
      and overlays. It also accepts additional Nixpkgs configuration settings.
    */
    mkNixpkgs = {
      system,
      nixpkgs,
      overlays ? [],
      config ? {allowUnfree = true;},
    }:
      import nixpkgs {inherit system config overlays;};
  };
in {
  inherit fs flakes nix;
}
