{
  description = "A terminal application for managing multiple AI coding assistants in isolated workspaces";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = rec {
          default = claude-squad;
          
          claude-squad = pkgs.buildGoModule rec {
            pname = "claude-squad";
            version = "1.0.2";

            src = ./.;

            vendorHash = "sha256-BduH6Vu+p5iFe1N5svZRsb9QuFlhf7usBjMsOtRn2nQ=";

            proxyVendor = false;

            propagatedBuildInputs = with pkgs; [
              tmux
              gh
            ];

            postInstall = ''
              # Create completions
              mkdir -p $out/share/bash-completion/completions
              $out/bin/claude-squad completion bash > $out/share/bash-completion/completions/claude-squad

              mkdir -p $out/share/zsh/site-functions
              $out/bin/claude-squad completion zsh > $out/share/zsh/site-functions/_claude-squad

              mkdir -p $out/share/fish/vendor_completions.d
              $out/bin/claude-squad completion fish > $out/share/fish/vendor_completions.d/claude-squad.fish
            '';

            meta = with pkgs.lib; {
              description = "Terminal application for managing multiple AI coding assistants in isolated workspaces";
              homepage = "https://github.com/smtg-ai/claude-squad";
              changelog = "https://github.com/smtg-ai/claude-squad/releases/tag/v${version}";
              license = licenses.agpl3Only;
              mainProgram = "claude-squad";
              platforms = platforms.linux;
            };
          };
        };

        apps = rec {
          default = claude-squad;
          claude-squad = flake-utils.lib.mkApp { drv = self.packages.${system}.claude-squad; };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            go
            tmux
            gh
            gopls
            gotools
          ];
        };
      });
}