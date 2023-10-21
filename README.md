# lib-extras

> A collection of extra functions to `nixpkgs.lib`!

This project aims to enhance the default `nixpkgs.lib` with additional (and maybe opinioated) functions.

## Functions

Below you can find the supported list of extra functions categorized by utility. The list for now is very small,
but more functions will be created for sure:

### Filesystem Functions:

- **collectNixFiles**: Collects `.nix` files recursively from a directory and returns them as an attribute set.

### Flake Functions:

- **mkApp**: Produces an "app" type for Nix flakes given a derivation and optional parameters.
- **filterPkgs**: Filters packages based on a specified attribute path and criteria.

### Nix Functions:

- **mkNixpkgs**: Imports and configures a Nixpkgs environment with custom settings, overlays, and system type.

## Requirements

- Nix with flake support.
- \[Optional\] `direnv` installed.

## Usage

To use `lib-extras` in your project:

1. Add this repository as an input to your flake.
   ```nix
   lib-extras = {
      url = "github:aldoborrero/lib-extras";
      inputs.nixpkgs.follows = "nixpkgs";
   };
   ```
1. Use the extended library in your Nix expressions:
   ```nix
   lib = nixpkgs.lib.extend (final: _: inputs.lib-extras.lib final);
   ```

## Development

When you're developing or contributing to `lib-extras`, the integrated `deevshell` provides a useful command to format the source tree:

```console
$ fmt
```

This command ensurees that all Nix code adheres to a standard format.

## Contributing

Contributions to `lib-extras` are welcome! Whether you're fixing bugs, improving documentation, or introducing a new feature, your efforts and contributions will be appreciated.

1. Fork this repository.
1. Create a new branch for your feature or fix.
1. Commit your changes with meaningful commit messages.
1. Open a pull request and provide a description of your changes.

## License

This project is licensed under the MIT license. For more details, see the `LICENSE` file in the repository.
