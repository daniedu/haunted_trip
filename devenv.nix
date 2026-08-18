{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    odin
    ols
    raylib
    watchexec
  ];

  processes.autobuild.exec = ''
    watchexec -e odin --no-default-ignore --restart -- odin run .
  '';
  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
