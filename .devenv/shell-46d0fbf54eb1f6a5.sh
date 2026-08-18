if [ -n "$PS1" ] && [ -e $HOME/.bashrc ]; then
    source $HOME/.bashrc;
fi

shopt -u expand_aliases
PATH=${PATH:-}
nix_saved_PATH="$PATH"
XDG_DATA_DIRS=${XDG_DATA_DIRS:-}
nix_saved_XDG_DATA_DIRS="$XDG_DATA_DIRS"
depsTargetTarget=''
export depsTargetTarget
NIX_BUILD_CORES='4'
export NIX_BUILD_CORES
NIX_LDFLAGS='-rpath /nix/store/9mv6xay5fax4xnf33pl3qshxbr8p0gbk-devenv-shell-env/lib  -L/nix/store/435j8fcfhr13nlbzinkrbz9q5lkxj08i-raylib-6.0/lib -L/nix/store/bcm3mwyfja8rd2y995vcnzq06b341nnz-libglvnd-1.7.0/lib -L/nix/store/w5ad04x91cc4rgn0dbx11biqjffz3giz-glu-9.0.3/lib -L/nix/store/6f2h1w0lr8kvj442cj3m756dgh323h06-libx11-1.8.13/lib -L/nix/store/vipia49afaix6ll31p90wvc774wl2n97-libxrender-0.9.12/lib -L/nix/store/hcn3biyg529b5wq9mqhlhdr5awiiwyc7-libxrandr-1.5.5/lib -L/nix/store/435j8fcfhr13nlbzinkrbz9q5lkxj08i-raylib-6.0/lib -L/nix/store/bcm3mwyfja8rd2y995vcnzq06b341nnz-libglvnd-1.7.0/lib -L/nix/store/w5ad04x91cc4rgn0dbx11biqjffz3giz-glu-9.0.3/lib -L/nix/store/6f2h1w0lr8kvj442cj3m756dgh323h06-libx11-1.8.13/lib -L/nix/store/vipia49afaix6ll31p90wvc774wl2n97-libxrender-0.9.12/lib -L/nix/store/hcn3biyg529b5wq9mqhlhdr5awiiwyc7-libxrandr-1.5.5/lib'
export NIX_LDFLAGS
buildPhase='{ echo "------------------------------------------------------------";
  echo " WARNING: the existence of this path is not guaranteed.";
  echo " It is an internal implementation detail for pkgs.mkShell.";
  echo "------------------------------------------------------------";
  echo;
  # Record all build inputs as runtime dependencies
  export;
} >> "$out"
'
export buildPhase
PKG_CONFIG='pkg-config'
export PKG_CONFIG
outputInfo='out'
depsBuildTargetPropagated=''
export depsBuildTargetPropagated
outputDoc='out'
declare -a envBuildTargetHooks=()
NIX_HARDENING_ENABLE='bindnow format fortify fortify3 libcxxhardeningfast pic relro stackclashprotection stackprotector strictflexarrays1 strictoverflow zerocallusedregs'
export NIX_HARDENING_ENABLE
cmakeFlags=''
export cmakeFlags
declare -a pkgsBuildHost=('/nix/store/k3xfi5kna47grqcnxmcrmr93zzkqxb95-bash-interactive-5.3p15-dev' '/nix/store/bwry105g7v5jspr41bx9x3fcfqsmfkq2-bash-interactive-5.3p15' '/nix/store/vhz63axfnij1wlfpsfxpcrzgd5rlnj99-odin-dev-2026-07a' '/nix/store/70c9cs03843v7c3n8rswabx14byyhnzg-ols-dev-2026-06' '/nix/store/435j8fcfhr13nlbzinkrbz9q5lkxj08i-raylib-6.0' '/nix/store/vpsgldgc2im5ac2hdjj6vrjf8aqj3g7h-glu-9.0.3-dev' '/nix/store/y5445kw5xwvmkhvz98s9vh3yxvss600i-libglvnd-1.7.0-dev' '/nix/store/bcm3mwyfja8rd2y995vcnzq06b341nnz-libglvnd-1.7.0' '/nix/store/w5ad04x91cc4rgn0dbx11biqjffz3giz-glu-9.0.3' '/nix/store/xds33yzfavin90p5k6wvvlbfil9rgzji-libx11-1.8.13-dev' '/nix/store/7ma35yanqhyxqzgwpydzk6aa44yg30dh-xorgproto-2025.1' '/nix/store/6f2h1w0lr8kvj442cj3m756dgh323h06-libx11-1.8.13' '/nix/store/lrnp12jryijizmqcac4hw3vr6yndm3b7-libxrandr-1.5.5-dev' '/nix/store/c8wfa2smaijcgyx4dhs2x63mkw6x3a5b-libxrender-0.9.12-dev' '/nix/store/vipia49afaix6ll31p90wvc774wl2n97-libxrender-0.9.12' '/nix/store/hcn3biyg529b5wq9mqhlhdr5awiiwyc7-libxrandr-1.5.5' '/nix/store/0fv8p1ja5z4294r2qd4j0g2mflrhmq6a-watchexec-2.5.1' '/nix/store/2l3a3fhc1nyp69mlq5ifb4mkb9mryb98-pkg-config-wrapper-0.29.2' '/nix/store/pzvcwi6y0vfmfpni6b52jwy9x6sj1yv1-patchelf-0.15.2' '/nix/store/ya8cl7vzwcaf32zwhkgs1xzrwwlk9g93-update-autotools-gnu-config-scripts-hook' '/nix/store/0y5xmdb7qfvimjwbq7ibg1xdgkgjwqng-no-broken-symlinks.sh' '/nix/store/cv1d7p48379km6a85h4zp6kr86brh32q-audit-tmpdir.sh' '/nix/store/85clx3b0xkdf58jn161iy80y5223ilbi-compress-man-pages.sh' '/nix/store/p3l1a5y7nllfyrjn2krlwgcc3z0cd3fq-make-symlinks-relative.sh' '/nix/store/5yzw0vhkyszf2d179m0qfkgxmp5wjjx4-move-docs.sh' '/nix/store/fyaryjvghbkpfnsyw97hb3lyb37s1pd6-move-lib64.sh' '/nix/store/kd4xwxjpjxi71jkm6ka0np72if9rm3y0-move-sbin.sh' '/nix/store/pag6l61paj1dc9sv15l7bm5c17xn5kyk-move-systemd-user-units.sh' '/nix/store/cmzya9irvxzlkh7lfy6i82gbp0saxqj3-multiple-outputs.sh' '/nix/store/x8c40nfigps493a07sdr2pm5s9j1cdc0-patch-shebangs.sh' '/nix/store/cickvswrvann041nqxb0rxilc46svw1n-prune-libtool-files.sh' '/nix/store/xyff06pkhki3qy1ls77w10s0v79c9il0-reproducible-builds.sh' '/nix/store/z7k98578dfzi6l3hsvbivzm7hfqlk0zc-set-source-date-epoch-to-latest.sh' '/nix/store/pilsssjjdxvdphlg2h19p0bfx5q0jzkn-strip.sh' '/nix/store/l5qkpzsr4gxvksh45b3nhxbkyr5cviar-gcc-wrapper-15.3.0' '/nix/store/ncjjjhkrbrlr21zr416sr315mxfi0y8q-binutils-wrapper-2.46' )
declare -a postUnpackHooks=('_updateSourceDateEpochFromSourceRoot' )
STRIP='strip'
export STRIP
NIX_STORE='/nix/store'
export NIX_STORE
declare -a pkgsBuildBuild=()
declare -a pkgsBuildTarget=()
NM='nm'
export NM
OSTYPE='linux-gnu'
READELF='readelf'
export READELF
MACHTYPE='x86_64-pc-linux-gnu'
system='x86_64-linux'
export system
CONFIG_SHELL='/nix/store/7ik8057hajl6vq9j40h3jracxjn0bb5x-bash-5.3p15/bin/bash'
export CONFIG_SHELL
LD='ld'
export LD
PS4='+ '
DEVENV_DOTFILE='/home/nixos/proyectos/wizardry_like/.devenv'
export DEVENV_DOTFILE
declare -a envBuildBuildHooks=()
declare -a postFixupHooks=('noBrokenSymlinksInAllOutputs' '_makeSymlinksRelative' '_multioutPropagateDev' )
initialPath='/nix/store/di26b1kkbammy0sj70nq5qzvfrh78wxl-coreutils-9.11 /nix/store/fcqbwp5hx5wh3lzf0457wmf0divknz7y-findutils-4.11.0 /nix/store/2fj4q3rg23fikdb43m039c967scsr5d9-diffutils-3.12 /nix/store/7mfsmbhsd3arnypipwm251rcd0b45riy-gnused-4.10 /nix/store/aak8d9mrdv9sgn0lcg7xss7wxdg9sqh3-gnugrep-3.12 /nix/store/l0pfzsyrxmgfbzxxzxpwi6j6mhnkyrcr-gawk-5.4.1 /nix/store/iwfv3zbkmmphvwqp05kd7r55n3vfcfyd-gnutar-1.35 /nix/store/8dlps0306xac4yf2m85iqk0k8ppbd5yx-gzip-1.14 /nix/store/ahlj2fipymncli1pmb8y5bbyjzqrw4zk-bzip2-1.0.8-bin /nix/store/pqqnhh0960k1a10jm41lgnq5vrxzs05x-gnumake-4.4.1 /nix/store/7ik8057hajl6vq9j40h3jracxjn0bb5x-bash-5.3p15 /nix/store/jdiqg2lw2bkpvfdw0rjdn6iaxv48rxpn-patch-2.8 /nix/store/75jq54q1qfv5n6hxxp8bd9yb6kc1yiz4-xz-5.8.3-bin /nix/store/784nd0cwrm99bzqwkx4fzd9j6vz4kxpm-file-5.48'
mesonFlags=''
export mesonFlags
outputDevdoc='REMOVE'
phases='buildPhase'
export phases
declare -a preConfigureHooks=('_multioutConfig' )
BASH='/nix/store/7ik8057hajl6vq9j40h3jracxjn0bb5x-bash-5.3p15/bin/bash'
declare -a envBuildHostHooks=()
depsBuildTarget=''
export depsBuildTarget
HOST_PATH='/nix/store/di26b1kkbammy0sj70nq5qzvfrh78wxl-coreutils-9.11/bin:/nix/store/fcqbwp5hx5wh3lzf0457wmf0divknz7y-findutils-4.11.0/bin:/nix/store/2fj4q3rg23fikdb43m039c967scsr5d9-diffutils-3.12/bin:/nix/store/7mfsmbhsd3arnypipwm251rcd0b45riy-gnused-4.10/bin:/nix/store/aak8d9mrdv9sgn0lcg7xss7wxdg9sqh3-gnugrep-3.12/bin:/nix/store/l0pfzsyrxmgfbzxxzxpwi6j6mhnkyrcr-gawk-5.4.1/bin:/nix/store/iwfv3zbkmmphvwqp05kd7r55n3vfcfyd-gnutar-1.35/bin:/nix/store/8dlps0306xac4yf2m85iqk0k8ppbd5yx-gzip-1.14/bin:/nix/store/ahlj2fipymncli1pmb8y5bbyjzqrw4zk-bzip2-1.0.8-bin/bin:/nix/store/pqqnhh0960k1a10jm41lgnq5vrxzs05x-gnumake-4.4.1/bin:/nix/store/7ik8057hajl6vq9j40h3jracxjn0bb5x-bash-5.3p15/bin:/nix/store/jdiqg2lw2bkpvfdw0rjdn6iaxv48rxpn-patch-2.8/bin:/nix/store/75jq54q1qfv5n6hxxp8bd9yb6kc1yiz4-xz-5.8.3-bin/bin:/nix/store/784nd0cwrm99bzqwkx4fzd9j6vz4kxpm-file-5.48/bin'
export HOST_PATH
stdenv='/nix/store/kmmhih3r2027rbq0ndw4vm6srdq6pl2c-stdenv-linux'
export stdenv
preferLocalBuild='1'
export preferLocalBuild
outputDevman='out'
doInstallCheck=''
export doInstallCheck
declare -a pkgsHostTarget=()
IFS=' 	
'
defaultNativeBuildInputs='/nix/store/pzvcwi6y0vfmfpni6b52jwy9x6sj1yv1-patchelf-0.15.2 /nix/store/ya8cl7vzwcaf32zwhkgs1xzrwwlk9g93-update-autotools-gnu-config-scripts-hook /nix/store/0y5xmdb7qfvimjwbq7ibg1xdgkgjwqng-no-broken-symlinks.sh /nix/store/cv1d7p48379km6a85h4zp6kr86brh32q-audit-tmpdir.sh /nix/store/85clx3b0xkdf58jn161iy80y5223ilbi-compress-man-pages.sh /nix/store/p3l1a5y7nllfyrjn2krlwgcc3z0cd3fq-make-symlinks-relative.sh /nix/store/5yzw0vhkyszf2d179m0qfkgxmp5wjjx4-move-docs.sh /nix/store/fyaryjvghbkpfnsyw97hb3lyb37s1pd6-move-lib64.sh /nix/store/kd4xwxjpjxi71jkm6ka0np72if9rm3y0-move-sbin.sh /nix/store/pag6l61paj1dc9sv15l7bm5c17xn5kyk-move-systemd-user-units.sh /nix/store/cmzya9irvxzlkh7lfy6i82gbp0saxqj3-multiple-outputs.sh /nix/store/x8c40nfigps493a07sdr2pm5s9j1cdc0-patch-shebangs.sh /nix/store/cickvswrvann041nqxb0rxilc46svw1n-prune-libtool-files.sh /nix/store/xyff06pkhki3qy1ls77w10s0v79c9il0-reproducible-builds.sh /nix/store/z7k98578dfzi6l3hsvbivzm7hfqlk0zc-set-source-date-epoch-to-latest.sh /nix/store/pilsssjjdxvdphlg2h19p0bfx5q0jzkn-strip.sh /nix/store/l5qkpzsr4gxvksh45b3nhxbkyr5cviar-gcc-wrapper-15.3.0'
DEVENV_ROOT='/home/nixos/proyectos/wizardry_like'
export DEVENV_ROOT
GREET='devenv'
export GREET
depsHostHost=''
export depsHostHost
declare -a unpackCmdHooks=('_defaultUnpack' )
allowSubstitutes=''
export allowSubstitutes
NIX_CC='/nix/store/l5qkpzsr4gxvksh45b3nhxbkyr5cviar-gcc-wrapper-15.3.0'
export NIX_CC
NIX_PKG_CONFIG_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu='1'
export NIX_PKG_CONFIG_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu
RANLIB='ranlib'
export RANLIB
outputBin='out'
outputMan='out'
prefix='/nix/store/9mv6xay5fax4xnf33pl3qshxbr8p0gbk-devenv-shell-env'
outputs='out'
export outputs
preConfigurePhases=' updateAutotoolsGnuConfigScriptsPhase'
out='/nix/store/9mv6xay5fax4xnf33pl3qshxbr8p0gbk-devenv-shell-env'
export out
AS='as'
export AS
doCheck=''
export doCheck
declare -a fixupOutputHooks=('if [ -z "${dontPatchELF-}" ]; then patchELF "$prefix"; fi' 'if [[ -z "${noAuditTmpdir-}" && -e "$prefix" ]]; then auditTmpdir "$prefix"; fi' 'if [ -z "${dontGzipMan-}" ]; then compressManPages "$prefix"; fi' '_moveLib64' '_moveSbin' '_moveSystemdUserUnits' 'patchShebangsAuto' '_pruneLibtoolFiles' '_doStrip' )
declare -a envTargetTargetHooks=()
declare -a propagatedBuildDepFiles=('propagated-build-build-deps' 'propagated-native-build-inputs' 'propagated-build-target-deps' )
depsTargetTargetPropagated=''
export depsTargetTargetPropagated
DEVENV_TASK_FILE='/nix/store/9dl5lgsmz3ysz3nq4cr47vzgf280gls0-tasks.json'
export DEVENV_TASK_FILE
STRINGS='strings'
export STRINGS
depsBuildBuild=''
export depsBuildBuild
OBJCOPY='objcopy'
export OBJCOPY
DEVENV_PROFILE='/nix/store/q4n5z7rzhjjc0h4j1yhbqf1v6w4kw132-devenv-profile'
export DEVENV_PROFILE
depsHostHostPropagated=''
export depsHostHostPropagated
NIX_BINTOOLS='/nix/store/ncjjjhkrbrlr21zr416sr315mxfi0y8q-binutils-wrapper-2.46'
export NIX_BINTOOLS
dontAddDisableDepTrack='1'
export dontAddDisableDepTrack
hardeningDisable=''
export hardeningDisable
NIX_BINTOOLS_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu='1'
export NIX_BINTOOLS_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu
XDG_DATA_DIRS='/nix/store/bwry105g7v5jspr41bx9x3fcfqsmfkq2-bash-interactive-5.3p15/share:/nix/store/vhz63axfnij1wlfpsfxpcrzgd5rlnj99-odin-dev-2026-07a/share:/nix/store/7ma35yanqhyxqzgwpydzk6aa44yg30dh-xorgproto-2025.1/share:/nix/store/6f2h1w0lr8kvj442cj3m756dgh323h06-libx11-1.8.13/share:/nix/store/hcn3biyg529b5wq9mqhlhdr5awiiwyc7-libxrandr-1.5.5/share:/nix/store/0fv8p1ja5z4294r2qd4j0g2mflrhmq6a-watchexec-2.5.1/share:/nix/store/2l3a3fhc1nyp69mlq5ifb4mkb9mryb98-pkg-config-wrapper-0.29.2/share:/nix/store/pzvcwi6y0vfmfpni6b52jwy9x6sj1yv1-patchelf-0.15.2/share'
export XDG_DATA_DIRS
shellHook='


# Override temp directories that stdenv set to NIX_BUILD_TOP.
# Only reset those that still point to the Nix build dir; leave
# any user/CI-supplied value intact.
for var in TMP TMPDIR TEMP TEMPDIR; do
  if [ -n "${!var-}" ] && [ "${!var}" = "${NIX_BUILD_TOP-}" ]; then
    export "$var"=/tmp
  fi
done
if [ -n "${NIX_BUILD_TOP-}" ]; then
  unset NIX_BUILD_TOP
fi

# set path to locales on non-NixOS Linux hosts
if [ -z "${LOCALE_ARCHIVE-}" ]; then
  export LOCALE_ARCHIVE=/nix/store/9536yx5h2hn6vspjg6bnizrdvz7syf4a-glibc-locales-2.42-67/lib/locale/locale-archive
fi


# Make `man <tool>` find the man pages of packages in the profile.
export MANPATH="$DEVENV_PROFILE/share/man:${MANPATH:+$MANPATH:}"

# direnv helper
if [ ! type -p direnv &>/dev/null && -f .envrc ]; then
  echo "An .envrc file was detected, but the direnv command is not installed."
  echo "To use this configuration, please install direnv: https://direnv.net/docs/installation.html"
fi

mkdir -p "$DEVENV_STATE"
if [ ! -L "$DEVENV_DOTFILE/profile" ] || [ "$(/nix/store/di26b1kkbammy0sj70nq5qzvfrh78wxl-coreutils-9.11/bin/readlink $DEVENV_DOTFILE/profile)" != "/nix/store/q4n5z7rzhjjc0h4j1yhbqf1v6w4kw132-devenv-profile" ]
then
  ln -snf /nix/store/q4n5z7rzhjjc0h4j1yhbqf1v6w4kw132-devenv-profile "$DEVENV_DOTFILE/profile"
fi
unset HOST_PATH NIX_BUILD_CORES __structuredAttrs buildInputs buildPhase builder depsBuildBuild depsBuildBuildPropagated depsBuildTarget depsBuildTargetPropagated depsHostHost depsHostHostPropagated depsTargetTarget depsTargetTargetPropagated dontAddDisableDepTrack doCheck doInstallCheck nativeBuildInputs out outputs patches phases preferLocalBuild propagatedBuildInputs propagatedNativeBuildInputs shell shellHook stdenv strictDeps

mkdir -p /run/user/1000/devenv-79827fb
ln -snf /run/user/1000/devenv-79827fb /home/nixos/proyectos/wizardry_like/.devenv/run




# Check whether the direnv integration is out of date.
{
  if [[ ":${DIRENV_ACTIVE-}:" == *":/home/nixos/proyectos/wizardry_like:"* ]]; then
    if [[ ! "${DEVENV_NO_DIRENVRC_OUTDATED_WARNING-}" == 1 && ! "${DEVENV_DIRENVRC_ROLLING_UPGRADE-}" == 1 ]]; then
      if [[ ${DEVENV_DIRENVRC_VERSION:-0} -lt 2 ]]; then
        direnv_line=$(grep --color=never -E "source_url.*cachix/devenv" .envrc || echo "")

        echo "✨ The direnv integration in your .envrc is out of date."
        echo ""
        echo -n "RECOMMENDED: devenv can now auto-upgrade the direnv integration. "
        if [[ -n "$direnv_line" ]]; then
          echo "To enable this feature, replace the following line in your .envrc:"
          echo ""
          echo "  $direnv_line"
          echo ""
          echo "with:"
          echo ""
          echo "  eval \"\$(devenv direnvrc)\""
        else
          echo "To enable this feature, replace the \`source_url\` line that fetches the direnvrc integration in your .envrc with:"
          echo ""
          echo "  eval \"$(devenv direnvrc)\""
        fi
        echo ""
          echo "If you prefer to continue managing the integration manually, follow the upgrade instructions at https://devenv.sh/integrations/direnv/."
          echo ""
          echo "To disable this message:"
          echo ""
          echo "  Add the following environment to your .envrc before \`use devenv\`:"
          echo ""
          echo "    export DEVENV_NO_DIRENVRC_OUTDATED_WARNING=1"
          echo ""
          echo "  Or set the following option in your devenv configuration:"
          echo ""
          echo "    devenv.warnOnNewVersion = false;"
          echo ""
      fi
    fi
  fi
} >&2

'
export shellHook
outputInclude='out'
IN_NIX_SHELL='impure'
export IN_NIX_SHELL
OPTERR='1'
_substituteStream_has_warned_replace_deprecation='false'
declare -a preFixupHooks=('_moveToShare' '_multioutDocs' '_multioutDevs' )
outputDev='out'
NIX_ENFORCE_NO_NATIVE='1'
export NIX_ENFORCE_NO_NATIVE
defaultBuildInputs=''
declare -a pkgsHostHost=()
NIX_NO_SELF_RPATH='1'
buildInputs=''
export buildInputs
depsBuildBuildPropagated=''
export depsBuildBuildPropagated
shell='/nix/store/7ik8057hajl6vq9j40h3jracxjn0bb5x-bash-5.3p15/bin/bash'
export shell
name='devenv-shell-env'
export name
HOSTTYPE='x86_64'
SOURCE_DATE_EPOCH='315532800'
export SOURCE_DATE_EPOCH
propagatedNativeBuildInputs=''
export propagatedNativeBuildInputs
CC='gcc'
export CC
CXX='g++'
export CXX
DEVENV_RUNTIME='/run/user/1000/devenv-79827fb'
export DEVENV_RUNTIME
pkg='/nix/store/l5qkpzsr4gxvksh45b3nhxbkyr5cviar-gcc-wrapper-15.3.0'
__structuredAttrs=''
export __structuredAttrs
strictDeps=''
export strictDeps
declare -a envHostHostHooks=('pkgConfigWrapper_addPkgConfigPath' 'ccWrapper_addCVars' 'bintoolsWrapper_addLDVars' )
PKG_CONFIG_PATH='/nix/store/k3xfi5kna47grqcnxmcrmr93zzkqxb95-bash-interactive-5.3p15-dev/lib/pkgconfig:/nix/store/435j8fcfhr13nlbzinkrbz9q5lkxj08i-raylib-6.0/lib/pkgconfig:/nix/store/vpsgldgc2im5ac2hdjj6vrjf8aqj3g7h-glu-9.0.3-dev/lib/pkgconfig:/nix/store/y5445kw5xwvmkhvz98s9vh3yxvss600i-libglvnd-1.7.0-dev/lib/pkgconfig:/nix/store/xds33yzfavin90p5k6wvvlbfil9rgzji-libx11-1.8.13-dev/lib/pkgconfig:/nix/store/7ma35yanqhyxqzgwpydzk6aa44yg30dh-xorgproto-2025.1/share/pkgconfig:/nix/store/lrnp12jryijizmqcac4hw3vr6yndm3b7-libxrandr-1.5.5-dev/lib/pkgconfig:/nix/store/c8wfa2smaijcgyx4dhs2x63mkw6x3a5b-libxrender-0.9.12-dev/lib/pkgconfig'
export PKG_CONFIG_PATH
propagatedBuildInputs=''
export propagatedBuildInputs
DEVENV_TASKS=''
export DEVENV_TASKS
LINENO='79'
NIX_CC_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu='1'
export NIX_CC_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu
OBJDUMP='objdump'
export OBJDUMP
OLDPWD=''
export OLDPWD
declare -a envHostTargetHooks=('pkgConfigWrapper_addPkgConfigPath' 'ccWrapper_addCVars' 'bintoolsWrapper_addLDVars' )
declare -a pkgsTargetTarget=()
declare -a propagatedHostDepFiles=('propagated-host-host-deps' 'propagated-build-inputs' )
DEVENV_STATE='/home/nixos/proyectos/wizardry_like/.devenv/state'
export DEVENV_STATE
SIZE='size'
export SIZE
PATH='/nix/store/bwry105g7v5jspr41bx9x3fcfqsmfkq2-bash-interactive-5.3p15/bin:/nix/store/vhz63axfnij1wlfpsfxpcrzgd5rlnj99-odin-dev-2026-07a/bin:/nix/store/70c9cs03843v7c3n8rswabx14byyhnzg-ols-dev-2026-06/bin:/nix/store/0fv8p1ja5z4294r2qd4j0g2mflrhmq6a-watchexec-2.5.1/bin:/nix/store/2l3a3fhc1nyp69mlq5ifb4mkb9mryb98-pkg-config-wrapper-0.29.2/bin:/nix/store/pzvcwi6y0vfmfpni6b52jwy9x6sj1yv1-patchelf-0.15.2/bin:/nix/store/l5qkpzsr4gxvksh45b3nhxbkyr5cviar-gcc-wrapper-15.3.0/bin:/nix/store/qrn789mrv652j7f5bcjp367npzpcyvdi-gcc-15.3.0/bin:/nix/store/8i8vavxai9s80xlx6y5kmiw7l63491m0-glibc-2.42-67-bin/bin:/nix/store/di26b1kkbammy0sj70nq5qzvfrh78wxl-coreutils-9.11/bin:/nix/store/ncjjjhkrbrlr21zr416sr315mxfi0y8q-binutils-wrapper-2.46/bin:/nix/store/advlbxfc5cg0jswl7zv40h2lzlxiksr6-binutils-2.46/bin:/nix/store/di26b1kkbammy0sj70nq5qzvfrh78wxl-coreutils-9.11/bin:/nix/store/fcqbwp5hx5wh3lzf0457wmf0divknz7y-findutils-4.11.0/bin:/nix/store/2fj4q3rg23fikdb43m039c967scsr5d9-diffutils-3.12/bin:/nix/store/7mfsmbhsd3arnypipwm251rcd0b45riy-gnused-4.10/bin:/nix/store/aak8d9mrdv9sgn0lcg7xss7wxdg9sqh3-gnugrep-3.12/bin:/nix/store/l0pfzsyrxmgfbzxxzxpwi6j6mhnkyrcr-gawk-5.4.1/bin:/nix/store/iwfv3zbkmmphvwqp05kd7r55n3vfcfyd-gnutar-1.35/bin:/nix/store/8dlps0306xac4yf2m85iqk0k8ppbd5yx-gzip-1.14/bin:/nix/store/ahlj2fipymncli1pmb8y5bbyjzqrw4zk-bzip2-1.0.8-bin/bin:/nix/store/pqqnhh0960k1a10jm41lgnq5vrxzs05x-gnumake-4.4.1/bin:/nix/store/7ik8057hajl6vq9j40h3jracxjn0bb5x-bash-5.3p15/bin:/nix/store/jdiqg2lw2bkpvfdw0rjdn6iaxv48rxpn-patch-2.8/bin:/nix/store/75jq54q1qfv5n6hxxp8bd9yb6kc1yiz4-xz-5.8.3-bin/bin:/nix/store/784nd0cwrm99bzqwkx4fzd9j6vz4kxpm-file-5.48/bin'
export PATH
nativeBuildInputs='/nix/store/k3xfi5kna47grqcnxmcrmr93zzkqxb95-bash-interactive-5.3p15-dev /nix/store/vhz63axfnij1wlfpsfxpcrzgd5rlnj99-odin-dev-2026-07a /nix/store/70c9cs03843v7c3n8rswabx14byyhnzg-ols-dev-2026-06 /nix/store/435j8fcfhr13nlbzinkrbz9q5lkxj08i-raylib-6.0 /nix/store/0fv8p1ja5z4294r2qd4j0g2mflrhmq6a-watchexec-2.5.1 /nix/store/2l3a3fhc1nyp69mlq5ifb4mkb9mryb98-pkg-config-wrapper-0.29.2'
export nativeBuildInputs
AR='ar'
export AR
outputLib='out'
builder='/nix/store/7ik8057hajl6vq9j40h3jracxjn0bb5x-bash-5.3p15/bin/bash'
export builder
NIX_CFLAGS_COMPILE=' -frandom-seed=9mv6xay5fa -isystem /nix/store/k3xfi5kna47grqcnxmcrmr93zzkqxb95-bash-interactive-5.3p15-dev/include -isystem /nix/store/435j8fcfhr13nlbzinkrbz9q5lkxj08i-raylib-6.0/include -isystem /nix/store/vpsgldgc2im5ac2hdjj6vrjf8aqj3g7h-glu-9.0.3-dev/include -isystem /nix/store/y5445kw5xwvmkhvz98s9vh3yxvss600i-libglvnd-1.7.0-dev/include -isystem /nix/store/xds33yzfavin90p5k6wvvlbfil9rgzji-libx11-1.8.13-dev/include -isystem /nix/store/7ma35yanqhyxqzgwpydzk6aa44yg30dh-xorgproto-2025.1/include -isystem /nix/store/lrnp12jryijizmqcac4hw3vr6yndm3b7-libxrandr-1.5.5-dev/include -isystem /nix/store/c8wfa2smaijcgyx4dhs2x63mkw6x3a5b-libxrender-0.9.12-dev/include -isystem /nix/store/k3xfi5kna47grqcnxmcrmr93zzkqxb95-bash-interactive-5.3p15-dev/include -isystem /nix/store/435j8fcfhr13nlbzinkrbz9q5lkxj08i-raylib-6.0/include -isystem /nix/store/vpsgldgc2im5ac2hdjj6vrjf8aqj3g7h-glu-9.0.3-dev/include -isystem /nix/store/y5445kw5xwvmkhvz98s9vh3yxvss600i-libglvnd-1.7.0-dev/include -isystem /nix/store/xds33yzfavin90p5k6wvvlbfil9rgzji-libx11-1.8.13-dev/include -isystem /nix/store/7ma35yanqhyxqzgwpydzk6aa44yg30dh-xorgproto-2025.1/include -isystem /nix/store/lrnp12jryijizmqcac4hw3vr6yndm3b7-libxrandr-1.5.5-dev/include -isystem /nix/store/c8wfa2smaijcgyx4dhs2x63mkw6x3a5b-libxrender-0.9.12-dev/include'
export NIX_CFLAGS_COMPILE
configureFlags=''
export configureFlags
declare -a propagatedTargetDepFiles=('propagated-target-target-deps' )
patches=''
export patches
_multioutDevs ()
{
 
    if [ "$(getAllOutputNames)" = "out" ] || [ -z "${moveToDev-1}" ]; then
        return;
    fi;
    moveToOutput include "${!outputInclude}";
    moveToOutput lib/pkgconfig "${!outputDev}";
    moveToOutput share/pkgconfig "${!outputDev}";
    moveToOutput lib/cmake "${!outputDev}";
    moveToOutput share/aclocal "${!outputDev}";
    for f in "${!outputDev}"/{lib,share}/pkgconfig/*.pc;
    do
        echo "Patching '$f' includedir to output ${!outputInclude}";
        sed -i "/^includedir=/s,=\${prefix},=${!outputInclude}," "$f";
    done
}
_moveSystemdUserUnits ()
{
 
    if [ "${dontMoveSystemdUserUnits:-0}" = 1 ]; then
        return;
    fi;
    if [ ! -e "${prefix:?}/lib/systemd/user" ]; then
        return;
    fi;
    local source="$prefix/lib/systemd/user";
    local target="$prefix/share/systemd/user";
    echo "moving $source/* to $target";
    mkdir -p "$target";
    ( shopt -s dotglob;
    for i in "$source"/*;
    do
        mv "$i" "$target";
    done );
    rmdir "$source";
    ln -s "$target" "$source"
}
definePhases ()
{
 
    if [ -z "${phases[*]:-}" ]; then
        phases="${prePhases[*]:-} unpackPhase patchPhase ${preConfigurePhases[*]:-}             configurePhase ${preBuildPhases[*]:-} buildPhase checkPhase             ${preInstallPhases[*]:-} installPhase ${preFixupPhases[*]:-} fixupPhase installCheckPhase             ${preDistPhases[*]:-} distPhase ${postPhases[*]:-}";
    fi
}
genericBuild ()
{
 
    export GZIP_NO_TIMESTAMPS=1;
    if [ -f "${buildCommandPath:-}" ]; then
        source "$buildCommandPath";
        return;
    fi;
    if [ -n "${buildCommand:-}" ]; then
        eval "$buildCommand";
        return;
    fi;
    definePhases;
    for curPhase in ${phases[*]};
    do
        runPhase "$curPhase";
    done
}
getAllOutputNames ()
{
 
    if [ -n "$__structuredAttrs" ]; then
        echo "${!outputs[*]}";
    else
        echo "$outputs";
    fi
}
distPhase ()
{
 
    runHook preDist;
    local flagsArray=();
    concatTo flagsArray distFlags distFlagsArray distTarget=dist;
    echo 'dist flags: %q' "${flagsArray[@]}";
    make ${makefile:+-f $makefile} "${flagsArray[@]}";
    if [ "${dontCopyDist:-0}" != 1 ]; then
        mkdir -p "$out/tarballs";
        cp -pvd ${tarballs[*]:-*.tar.gz} "$out/tarballs";
    fi;
    runHook postDist
}
findInputs ()
{
 
    local -r pkg="$1";
    local -r hostOffset="$2";
    local -r targetOffset="$3";
    (( hostOffset <= targetOffset )) || exit 1;
    local varVar="${pkgAccumVarVars[hostOffset + 1]}";
    local varRef="$varVar[$((targetOffset - hostOffset))]";
    local var="${!varRef}";
    unset -v varVar varRef;
    local varSlice="$var[*]";
    case " ${!varSlice-} " in 
        *" $pkg "*)
            return 0
        ;;
    esac;
    unset -v varSlice;
    eval "$var"'+=("$pkg")';
    if ! [ -e "$pkg" ]; then
        echo "build input $pkg does not exist" 1>&2;
        exit 1;
    fi;
    function mapOffset () 
    { 
        local -r inputOffset="$1";
        local -n outputOffset="$2";
        if (( inputOffset <= 0 )); then
            outputOffset=$((inputOffset + hostOffset));
        else
            outputOffset=$((inputOffset - 1 + targetOffset));
        fi
    };
    local relHostOffset;
    for relHostOffset in "${allPlatOffsets[@]}";
    do
        local files="${propagatedDepFilesVars[relHostOffset + 1]}";
        local hostOffsetNext;
        mapOffset "$relHostOffset" hostOffsetNext;
        (( -1 <= hostOffsetNext && hostOffsetNext <= 1 )) || continue;
        local relTargetOffset;
        for relTargetOffset in "${allPlatOffsets[@]}";
        do
            (( "$relHostOffset" <= "$relTargetOffset" )) || continue;
            local fileRef="${files}[$relTargetOffset - $relHostOffset]";
            local file="${!fileRef}";
            unset -v fileRef;
            local targetOffsetNext;
            mapOffset "$relTargetOffset" targetOffsetNext;
            (( -1 <= hostOffsetNext && hostOffsetNext <= 1 )) || continue;
            [[ -f "$pkg/nix-support/$file" ]] || continue;
            local pkgNext;
            read -r -d '' pkgNext < "$pkg/nix-support/$file" || true;
            for pkgNext in $pkgNext;
            do
                findInputs "$pkgNext" "$hostOffsetNext" "$targetOffsetNext";
            done;
        done;
    done
}
_nixLogWithLevel ()
{
 
    [[ -z ${NIX_LOG_FD-} || ${NIX_DEBUG:-0} -lt ${1:?} ]] && return 0;
    local logLevel;
    case "${1:?}" in 
        0)
            logLevel=ERROR
        ;;
        1)
            logLevel=WARN
        ;;
        2)
            logLevel=NOTICE
        ;;
        3)
            logLevel=INFO
        ;;
        4)
            logLevel=TALKATIVE
        ;;
        5)
            logLevel=CHATTY
        ;;
        6)
            logLevel=DEBUG
        ;;
        7)
            logLevel=VOMIT
        ;;
        *)
            echo "_nixLogWithLevel: called with invalid log level: ${1:?}" >&"$NIX_LOG_FD";
            return 1
        ;;
    esac;
    local callerName="${FUNCNAME[2]}";
    if [[ $callerName == "_callImplicitHook" ]]; then
        callerName="${hookName:?}";
    fi;
    printf "%s: %s: %s\n" "$logLevel" "$callerName" "${2:?}" >&"$NIX_LOG_FD"
}
_moveToShare ()
{
 
    if [ -n "$__structuredAttrs" ]; then
        if [ -z "${forceShare-}" ]; then
            forceShare=(man doc info);
        fi;
    else
        forceShare=(${forceShare:-man doc info});
    fi;
    if [[ -z "$out" ]]; then
        return;
    fi;
    for d in "${forceShare[@]}";
    do
        if [ -d "$out/$d" ]; then
            if [ -d "$out/share/$d" ]; then
                echo "both $d/ and share/$d/ exist!";
            else
                echo "moving $out/$d to $out/share/$d";
                mkdir -p $out/share;
                mv $out/$d $out/share/;
            fi;
        fi;
    done
}
_assignFirst ()
{
 
    local varName="$1";
    local _var;
    local REMOVE=REMOVE;
    shift;
    for _var in "$@";
    do
        if [ -n "${!_var-}" ]; then
            eval "${varName}"="${_var}";
            return;
        fi;
    done;
    echo;
    echo "error: _assignFirst: could not find a non-empty variable whose name to assign to ${varName}.";
    echo "       The following variables were all unset or empty:";
    echo "           $*";
    if [ -z "${out:-}" ]; then
        echo '       If you do not want an "out" output in your derivation, make sure to define';
        echo '       the other specific required outputs. This can be achieved by picking one';
        echo "       of the above as an output.";
        echo '       You do not have to remove "out" if you want to have a different default';
        echo '       output, because the first output is taken as a default.';
        echo;
    fi;
    return 1
}
_multioutConfig ()
{
 
    if [ "$(getAllOutputNames)" = "out" ] || [ -z "${setOutputFlags-1}" ]; then
        return;
    fi;
    if [ -z "${shareDocName:-}" ]; then
        local confScript="${configureScript:-}";
        if [ -z "$confScript" ] && [ -x ./configure ]; then
            confScript=./configure;
        fi;
        if [ -f "$confScript" ]; then
            local shareDocName="$(sed -n "s/^PACKAGE_TARNAME='\(.*\)'$/\1/p" < "$confScript")";
        fi;
        if [ -z "$shareDocName" ] || echo "$shareDocName" | grep -q '[^a-zA-Z0-9_-]'; then
            shareDocName="$(echo "$name" | sed 's/-[^a-zA-Z].*//')";
        fi;
    fi;
    prependToVar configureFlags --bindir="${!outputBin}"/bin --sbindir="${!outputBin}"/sbin --includedir="${!outputInclude}"/include --mandir="${!outputMan}"/share/man --infodir="${!outputInfo}"/share/info --docdir="${!outputDoc}"/share/doc/"${shareDocName}" --libdir="${!outputLib}"/lib --libexecdir="${!outputLib}"/libexec --localedir="${!outputLib}"/share/locale;
    prependToVar installFlags pkgconfigdir="${!outputDev}"/lib/pkgconfig m4datadir="${!outputDev}"/share/aclocal aclocaldir="${!outputDev}"/share/aclocal
}
activatePackage ()
{
 
    local pkg="$1";
    local -r hostOffset="$2";
    local -r targetOffset="$3";
    (( hostOffset <= targetOffset )) || exit 1;
    if [ -f "$pkg" ]; then
        nixTalkativeLog "sourcing setup hook '$pkg'";
        source "$pkg";
    fi;
    if [[ -z "${strictDeps-}" || "$hostOffset" -le -1 ]]; then
        addToSearchPath _PATH "$pkg/bin";
    fi;
    if (( hostOffset <= -1 )); then
        addToSearchPath _XDG_DATA_DIRS "$pkg/share";
    fi;
    if [[ "$hostOffset" -eq 0 && -d "$pkg/bin" ]]; then
        addToSearchPath _HOST_PATH "$pkg/bin";
    fi;
    if [[ -f "$pkg/nix-support/setup-hook" ]]; then
        nixTalkativeLog "sourcing setup hook '$pkg/nix-support/setup-hook'";
        source "$pkg/nix-support/setup-hook";
    fi
}
nixVomitLog ()
{
 
    _nixLogWithLevel 7 "$*"
}
concatStringsSep ()
{
 
    local sep="$1";
    local name="$2";
    local type oldifs;
    if type=$(declare -p "$name" 2> /dev/null); then
        local -n nameref="$name";
        case "${type#* }" in 
            -A*)
                echo "concatStringsSep(): ERROR: trying to use concatStringsSep on an associative array." 1>&2;
                return 1
            ;;
            -a*)
                local IFS="$(printf '\036')"
            ;;
            *)
                local IFS=" "
            ;;
        esac;
        local ifs_separated="${nameref[*]}";
        echo -n "${ifs_separated//"$IFS"/"$sep"}";
    fi
}
isELF ()
{
 
    local fn="$1";
    local fd;
    local magic;
    exec {fd}< "$fn";
    LANG=C read -r -n 4 -u "$fd" magic;
    exec {fd}>&-;
    if [ "$magic" = 'ELF' ]; then
        return 0;
    else
        return 1;
    fi
}
nixErrorLog ()
{
 
    _nixLogWithLevel 0 "$*"
}
stripHash ()
{
 
    local strippedName casematchOpt=0;
    strippedName="$(basename -- "$1")";
    shopt -q nocasematch && casematchOpt=1;
    shopt -u nocasematch;
    if [[ "$strippedName" =~ ^[a-z0-9]{32}- ]]; then
        echo "${strippedName:33}";
    else
        echo "$strippedName";
    fi;
    if (( casematchOpt )); then
        shopt -s nocasematch;
    fi
}
fixupPhase ()
{
 
    local output;
    for output in $(getAllOutputNames);
    do
        if [ -e "${!output}" ]; then
            chmod -R u+w,u-s,g-s "${!output}";
        fi;
    done;
    runHook preFixup;
    local output;
    for output in $(getAllOutputNames);
    do
        prefix="${!output}" runHook fixupOutput;
    done;
    recordPropagatedDependencies;
    if [ -n "${setupHook:-}" ]; then
        mkdir -p "${!outputDev}/nix-support";
        substituteAll "$setupHook" "${!outputDev}/nix-support/setup-hook";
    fi;
    if [ -n "${setupHooks:-}" ]; then
        mkdir -p "${!outputDev}/nix-support";
        local hook;
        for hook in ${setupHooks[@]};
        do
            local content;
            consumeEntire content < "$hook";
            substituteAllStream content "file '$hook'" >> "${!outputDev}/nix-support/setup-hook";
            unset -v content;
        done;
        unset -v hook;
    fi;
    if [ -n "${propagatedUserEnvPkgs[*]:-}" ]; then
        mkdir -p "${!outputBin}/nix-support";
        printWords "${propagatedUserEnvPkgs[@]}" > "${!outputBin}/nix-support/propagated-user-env-packages";
    fi;
    runHook postFixup
}
getHostRoleEnvHook ()
{
 
    getRole "$depHostOffset"
}
checkPhase ()
{
 
    runHook preCheck;
    if [[ -z "${foundMakefile:-}" ]]; then
        echo "no Makefile or custom checkPhase, doing nothing";
        runHook postCheck;
        return;
    fi;
    if [[ -z "${checkTarget:-}" ]]; then
        if make -n ${makefile:+-f $makefile} check > /dev/null 2>&1; then
            checkTarget="check";
        else
            if make -n ${makefile:+-f $makefile} test > /dev/null 2>&1; then
                checkTarget="test";
            fi;
        fi;
    fi;
    if [[ -z "${checkTarget:-}" ]]; then
        echo "no check/test target in ${makefile:-Makefile}, doing nothing";
    else
        local flagsArray=(${enableParallelChecking:+-j${NIX_BUILD_CORES}} SHELL="$SHELL");
        concatTo flagsArray makeFlags makeFlagsArray checkFlags=VERBOSE=y checkFlagsArray checkTarget;
        echoCmd 'check flags' "${flagsArray[@]}";
        make ${makefile:+-f $makefile} "${flagsArray[@]}";
        unset flagsArray;
    fi;
    runHook postCheck
}
showPhaseFooter ()
{
 
    local phase="$1";
    local startTime="$2";
    local endTime="$3";
    local delta=$(( endTime - startTime ));
    (( delta < 30 )) && return;
    local H=$((delta/3600));
    local M=$((delta%3600/60));
    local S=$((delta%60));
    echo -n "$phase completed in ";
    (( H > 0 )) && echo -n "$H hours ";
    (( M > 0 )) && echo -n "$M minutes ";
    echo "$S seconds"
}
patchShebangs ()
{
 
    local pathName;
    local update=false;
    while [[ $# -gt 0 ]]; do
        case "$1" in 
            --host)
                pathName=HOST_PATH;
                shift
            ;;
            --build)
                pathName=PATH;
                shift
            ;;
            --update)
                update=true;
                shift
            ;;
            --)
                shift;
                break
            ;;
            -* | --*)
                echo "Unknown option $1 supplied to patchShebangs" 1>&2;
                return 1
            ;;
            *)
                break
            ;;
        esac;
    done;
    echo "patching script interpreter paths in $@";
    local f;
    local oldPath;
    local newPath;
    local arg0;
    local args;
    local oldInterpreterLine;
    local newInterpreterLine;
    if [[ $# -eq 0 ]]; then
        echo "No arguments supplied to patchShebangs" 1>&2;
        return 0;
    fi;
    local f;
    while IFS= read -r -d '' f; do
        isScript "$f" || continue;
        read -r oldInterpreterLine < "$f" || [ "$oldInterpreterLine" ];
        read -r oldPath arg0 args <<< "${oldInterpreterLine:2}";
        if [[ -z "${pathName:-}" ]]; then
            if [[ -n $strictDeps && $f == "$NIX_STORE"* ]]; then
                pathName=HOST_PATH;
            else
                pathName=PATH;
            fi;
        fi;
        if [[ "$oldPath" == *"/bin/env" ]]; then
            if [[ $arg0 == "-S" ]]; then
                arg0=${args%% *};
                [[ "$args" == *" "* ]] && args=${args#* } || args=;
                newPath="$(PATH="${!pathName}" type -P "env" || true)";
                args="-S $(PATH="${!pathName}" type -P "$arg0" || true) $args";
            else
                if [[ $arg0 == "-"* || $arg0 == *"="* ]]; then
                    echo "$f: unsupported interpreter directive \"$oldInterpreterLine\" (set dontPatchShebangs=1 and handle shebang patching yourself)" 1>&2;
                    exit 1;
                else
                    newPath="$(PATH="${!pathName}" type -P "$arg0" || true)";
                fi;
            fi;
        else
            if [[ -z $oldPath ]]; then
                oldPath="/bin/sh";
            fi;
            newPath="$(PATH="${!pathName}" type -P "$(basename "$oldPath")" || true)";
            args="$arg0 $args";
        fi;
        newInterpreterLine="$newPath $args";
        newInterpreterLine=${newInterpreterLine%${newInterpreterLine##*[![:space:]]}};
        if [[ -n "$oldPath" && ( "$update" == true || "${oldPath:0:${#NIX_STORE}}" != "$NIX_STORE" ) ]]; then
            if [[ -n "$newPath" && "$newPath" != "$oldPath" ]]; then
                echo "$f: interpreter directive changed from \"$oldInterpreterLine\" to \"$newInterpreterLine\"";
                escapedInterpreterLine=${newInterpreterLine//\\/\\\\};
                timestamp=$(stat --printf "%y" "$f");
                tmpFile=$(mktemp -t patchShebangs.XXXXXXXXXX);
                sed -e "1 s|.*|#\!$escapedInterpreterLine|" "$f" > "$tmpFile";
                local restoreReadOnly;
                if [[ ! -w "$f" ]]; then
                    chmod +w "$f";
                    restoreReadOnly=true;
                fi;
                cat "$tmpFile" > "$f";
                rm "$tmpFile";
                if [[ -n "${restoreReadOnly:-}" ]]; then
                    chmod -w "$f";
                fi;
                touch --date "$timestamp" "$f";
            fi;
        fi;
    done < <(find "$@" -type f -perm -0100 -print0)
}
nixChattyLog ()
{
 
    _nixLogWithLevel 5 "$*"
}
_activatePkgs ()
{
 
    local hostOffset targetOffset;
    local pkg;
    for hostOffset in "${allPlatOffsets[@]}";
    do
        local pkgsVar="${pkgAccumVarVars[hostOffset + 1]}";
        for targetOffset in "${allPlatOffsets[@]}";
        do
            (( hostOffset <= targetOffset )) || continue;
            local pkgsRef="${pkgsVar}[$targetOffset - $hostOffset]";
            local pkgsSlice="${!pkgsRef}[@]";
            for pkg in ${!pkgsSlice+"${!pkgsSlice}"};
            do
                activatePackage "$pkg" "$hostOffset" "$targetOffset";
            done;
        done;
    done
}
installPhase ()
{
 
    runHook preInstall;
    if [[ -z "${makeFlags-}" && -z "${makefile:-}" && ! ( -e Makefile || -e makefile || -e GNUmakefile ) ]]; then
        echo "no Makefile or custom installPhase, doing nothing";
        runHook postInstall;
        return;
    else
        foundMakefile=1;
    fi;
    if [ -n "$prefix" ]; then
        mkdir -p "$prefix";
    fi;
    local flagsArray=(${enableParallelInstalling:+-j${NIX_BUILD_CORES}} SHELL="$SHELL");
    concatTo flagsArray makeFlags makeFlagsArray installFlags installFlagsArray installTargets=install;
    echoCmd 'install flags' "${flagsArray[@]}";
    make ${makefile:+-f $makefile} "${flagsArray[@]}";
    unset flagsArray;
    runHook postInstall
}
patchPhase ()
{
 
    runHook prePatch;
    local -a patchesArray;
    concatTo patchesArray patches;
    local -a flagsArray;
    concatTo flagsArray patchFlags=-p1;
    for i in "${patchesArray[@]}";
    do
        echo "applying patch $i";
        local uncompress=cat;
        case "$i" in 
            *.gz)
                uncompress="gzip -d"
            ;;
            *.bz2)
                uncompress="bzip2 -d"
            ;;
            *.xz)
                uncompress="xz -d"
            ;;
            *.lzma)
                uncompress="lzma -d"
            ;;
        esac;
        $uncompress < "$i" 2>&1 | patch "${flagsArray[@]}";
    done;
    runHook postPatch
}
ccWrapper_addCVars ()
{
 
    local role_post;
    getHostRoleEnvHook;
    local found=;
    if [ -d "$1/include" ]; then
        export NIX_CFLAGS_COMPILE${role_post}+=" -isystem $1/include";
        found=1;
    fi;
    if [ -d "$1/Library/Frameworks" ]; then
        export NIX_CFLAGS_COMPILE${role_post}+=" -iframework $1/Library/Frameworks";
        found=1;
    fi;
    if [[ -n "" && -n ${NIX_STORE:-} && -n $found ]]; then
        local scrubbed="$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${1#"$NIX_STORE"/*-}";
        export NIX_CFLAGS_COMPILE${role_post}+=" -fmacro-prefix-map=$1=$scrubbed";
    fi
}
_callImplicitHook ()
{
 
    local def="$1";
    local hookName="$2";
    if declare -F "$hookName" > /dev/null; then
        nixTalkativeLog "calling implicit '$hookName' function hook";
        "$hookName";
    else
        if type -p "$hookName" > /dev/null; then
            nixTalkativeLog "sourcing implicit '$hookName' script hook";
            source "$hookName";
        else
            if [ -n "${!hookName:-}" ]; then
                nixTalkativeLog "evaling implicit '$hookName' string hook";
                eval "${!hookName}";
            else
                return "$def";
            fi;
        fi;
    fi
}
addToSearchPathWithCustomDelimiter ()
{
 
    local delimiter="$1";
    local varName="$2";
    local dir="$3";
    if [[ -d "$dir" && "${!varName:+${delimiter}${!varName}${delimiter}}" != *"${delimiter}${dir}${delimiter}"* ]]; then
        export "${varName}=${!varName:+${!varName}${delimiter}}${dir}";
    fi
}
_pruneLibtoolFiles ()
{
 
    if [ "${dontPruneLibtoolFiles-}" ] || [ ! -e "$prefix" ]; then
        return;
    fi;
    find "$prefix" -type f -name '*.la' -exec grep -q '^# Generated by .*libtool' {} \; -exec grep -q "^old_library=''" {} \; -exec sed -i {} -e "/^dependency_libs='[^']/ c dependency_libs='' #pruned" \;
}
_updateSourceDateEpochFromSourceRoot ()
{
 
    if [ -n "$sourceRoot" ]; then
        updateSourceDateEpoch "$sourceRoot";
    fi
}
_addRpathPrefix ()
{
 
    if [ "${NIX_NO_SELF_RPATH:-0}" != 1 ]; then
        export NIX_LDFLAGS="-rpath $1/lib ${NIX_LDFLAGS-}";
    fi
}
buildPhase ()
{
 
    runHook preBuild;
    if [[ -z "${makeFlags-}" && -z "${makefile:-}" && ! ( -e Makefile || -e makefile || -e GNUmakefile ) ]]; then
        echo "no Makefile or custom buildPhase, doing nothing";
    else
        foundMakefile=1;
        local flagsArray=(${enableParallelBuilding:+-j${NIX_BUILD_CORES}} SHELL="$SHELL");
        concatTo flagsArray makeFlags makeFlagsArray buildFlags buildFlagsArray;
        echoCmd 'build flags' "${flagsArray[@]}";
        make ${makefile:+-f $makefile} "${flagsArray[@]}";
        unset flagsArray;
    fi;
    runHook postBuild
}
dumpVars ()
{
 
    if [[ "${noDumpEnvVars:-0}" != 1 && -d "$NIX_BUILD_TOP" ]]; then
        local old_umask;
        old_umask=$(umask);
        umask 0077;
        export 2> /dev/null > "$NIX_BUILD_TOP/env-vars";
        umask "$old_umask";
    fi
}
exitHandler ()
{
 
    exitCode="$?";
    set +e;
    if [ -n "${showBuildStats:-}" ]; then
        read -r -d '' -a buildTimes < <(times);
        echo "build times:";
        echo "user time for the shell             ${buildTimes[0]}";
        echo "system time for the shell           ${buildTimes[1]}";
        echo "user time for all child processes   ${buildTimes[2]}";
        echo "system time for all child processes ${buildTimes[3]}";
    fi;
    if (( "$exitCode" != 0 )); then
        runHook failureHook;
        if [ -n "${succeedOnFailure:-}" ]; then
            echo "build failed with exit code $exitCode (ignored)";
            mkdir -p "$out/nix-support";
            printf "%s" "$exitCode" > "$out/nix-support/failed";
            exit 0;
        fi;
    else
        runHook exitHook;
    fi;
    return "$exitCode"
}
isMachO ()
{
 
    local fn="$1";
    local fd;
    local magic;
    exec {fd}< "$fn";
    LANG=C read -r -n 4 -u "$fd" magic;
    exec {fd}>&-;
    if [[ "$magic" = $(echo -ne "\xfe\xed\xfa\xcf") || "$magic" = $(echo -ne "\xcf\xfa\xed\xfe") ]]; then
        return 0;
    else
        if [[ "$magic" = $(echo -ne "\xfe\xed\xfa\xce") || "$magic" = $(echo -ne "\xce\xfa\xed\xfe") ]]; then
            return 0;
        else
            if [[ "$magic" = $(echo -ne "\xca\xfe\xba\xbe") || "$magic" = $(echo -ne "\xbe\xba\xfe\xca") ]]; then
                return 0;
            else
                return 1;
            fi;
        fi;
    fi
}
mapOffset ()
{
 
    local -r inputOffset="$1";
    local -n outputOffset="$2";
    if (( inputOffset <= 0 )); then
        outputOffset=$((inputOffset + hostOffset));
    else
        outputOffset=$((inputOffset - 1 + targetOffset));
    fi
}
nixLog ()
{
 
    [[ -z ${NIX_LOG_FD-} ]] && return 0;
    local callerName="${FUNCNAME[1]}";
    if [[ $callerName == "_callImplicitHook" ]]; then
        callerName="${hookName:?}";
    fi;
    printf "%s: %s\n" "$callerName" "$*" >&"$NIX_LOG_FD"
}
nixNoticeLog ()
{
 
    _nixLogWithLevel 2 "$*"
}
pkgConfigWrapper_addPkgConfigPath ()
{
 
    local role_post;
    getHostRoleEnvHook;
    addToSearchPath "PKG_CONFIG_PATH${role_post}" "$1/lib/pkgconfig";
    addToSearchPath "PKG_CONFIG_PATH${role_post}" "$1/share/pkgconfig"
}
updateSourceDateEpoch ()
{
 
    local path="$1";
    [[ $path == -* ]] && path="./$path";
    local -a res=($(find "$path" -type f -not -newer "$NIX_BUILD_TOP/.." -printf '%T@ "%p"\0' | sort -n --zero-terminated | tail -n1 --zero-terminated | head -c -1));
    local time="${res[0]//\.[0-9]*/}";
    local newestFile="${res[1]}";
    if [ "${time:-0}" -gt "$SOURCE_DATE_EPOCH" ]; then
        echo "setting SOURCE_DATE_EPOCH to timestamp $time of file $newestFile";
        export SOURCE_DATE_EPOCH="$time";
        local now="$(date +%s)";
        if [ "$time" -gt $((now - 60)) ]; then
            echo "warning: file $newestFile may be generated; SOURCE_DATE_EPOCH may be non-deterministic";
        fi;
    fi
}
runOneHook ()
{
 
    local hookName="$1";
    shift;
    local hooksSlice="${hookName%Hook}Hooks[@]";
    local hook ret=1;
    for hook in "_callImplicitHook 1 $hookName" ${!hooksSlice+"${!hooksSlice}"};
    do
        _logHook "$hookName" "$hook" "$@";
        if _eval "$hook" "$@"; then
            ret=0;
            break;
        fi;
    done;
    return "$ret"
}
stripDirs ()
{
 
    local cmd="$1";
    local ranlibCmd="$2";
    local paths="$3";
    local stripFlags="$4";
    local excludeFlags=();
    local pathsNew=;
    [ -z "$cmd" ] && echo "stripDirs: Strip command is empty" 1>&2 && exit 1;
    [ -z "$ranlibCmd" ] && echo "stripDirs: Ranlib command is empty" 1>&2 && exit 1;
    local pattern;
    if [ -n "${stripExclude:-}" ]; then
        for pattern in "${stripExclude[@]}";
        do
            excludeFlags+=(-a '!' '(' -name "$pattern" -o -wholename "$prefix/$pattern" ')');
        done;
    fi;
    local p;
    for p in ${paths};
    do
        if [ -e "$prefix/$p" ]; then
            pathsNew="${pathsNew} $prefix/$p";
        fi;
    done;
    paths=${pathsNew};
    if [ -n "${paths}" ]; then
        echo "stripping (with command $cmd and flags $stripFlags) in $paths";
        local striperr;
        striperr="$(mktemp --tmpdir="$TMPDIR" 'striperr.XXXXXX')";
        find $paths -type f "${excludeFlags[@]}" -a '!' -path "$prefix/lib/debug/*" -printf '%D-%i,%p\0' | sort -t, -k1,1 -u -z | cut -d, -f2- -z | xargs -r -0 -n1 -P "$NIX_BUILD_CORES" -- $cmd $stripFlags 2> "$striperr" || exit_code=$?;
        [[ "$exit_code" = 123 || -z "$exit_code" ]] || ( cat "$striperr" 1>&2 && exit 1 );
        rm "$striperr";
        find $paths -name '*.a' -type f -exec $ranlibCmd '{}' \; 2> /dev/null;
    fi
}
addEnvHooks ()
{
 
    local depHostOffset="$1";
    shift;
    local pkgHookVarsSlice="${pkgHookVarVars[$depHostOffset + 1]}[@]";
    local pkgHookVar;
    for pkgHookVar in "${!pkgHookVarsSlice}";
    do
        eval "${pkgHookVar}s"'+=("$@")';
    done
}
getHostRole ()
{
 
    getRole "$hostOffset"
}
getTargetRole ()
{
 
    getRole "$targetOffset"
}
_moveLib64 ()
{
 
    if [ "${dontMoveLib64-}" = 1 ]; then
        return;
    fi;
    if [ ! -e "$prefix/lib64" -o -L "$prefix/lib64" ]; then
        return;
    fi;
    echo "moving $prefix/lib64/* to $prefix/lib";
    mkdir -p $prefix/lib;
    shopt -s dotglob;
    for i in $prefix/lib64/*;
    do
        mv --no-clobber "$i" $prefix/lib;
    done;
    shopt -u dotglob;
    rmdir $prefix/lib64;
    ln -s lib $prefix/lib64
}
concatTo ()
{
 
    local -;
    set -o noglob;
    local -n targetref="$1";
    shift;
    local arg default name type;
    for arg in "$@";
    do
        IFS="=" read -r name default <<< "$arg";
        local -n nameref="$name";
        if [[ -z "${nameref[*]}" && -n "$default" ]]; then
            targetref+=("$default");
        else
            if type=$(declare -p "$name" 2> /dev/null); then
                case "${type#* }" in 
                    -A*)
                        echo "concatTo(): ERROR: trying to use concatTo on an associative array." 1>&2;
                        return 1
                    ;;
                    -a*)
                        targetref+=("${nameref[@]}")
                    ;;
                    *)
                        if [[ "$name" = *"Array" ]]; then
                            nixErrorLog "concatTo(): $name is not declared as array, treating as a singleton. This will become an error in future";
                            targetref+=(${nameref+"${nameref[@]}"});
                        else
                            targetref+=(${nameref-});
                        fi
                    ;;
                esac;
            fi;
        fi;
    done
}
getRole ()
{
 
    case $1 in 
        -1)
            role_post='_FOR_BUILD'
        ;;
        0)
            role_post=''
        ;;
        1)
            role_post='_FOR_TARGET'
        ;;
        *)
            echo "binutils-wrapper-2.46: used as improper sort of dependency" 1>&2;
            return 1
        ;;
    esac
}
consumeEntire ()
{
 
    if IFS='' read -r -d '' "$1"; then
        echo "consumeEntire(): ERROR: Input null bytes, won't process" 1>&2;
        return 1;
    fi
}
_overrideFirst ()
{
 
    if [ -z "${!1-}" ]; then
        _assignFirst "$@";
    fi
}
installCheckPhase ()
{
 
    runHook preInstallCheck;
    if [[ -z "${foundMakefile:-}" ]]; then
        echo "no Makefile or custom installCheckPhase, doing nothing";
    else
        if [[ -z "${installCheckTarget:-}" ]] && ! make -n ${makefile:+-f $makefile} "${installCheckTarget:-installcheck}" > /dev/null 2>&1; then
            echo "no installcheck target in ${makefile:-Makefile}, doing nothing";
        else
            local flagsArray=(${enableParallelChecking:+-j${NIX_BUILD_CORES}} SHELL="$SHELL");
            concatTo flagsArray makeFlags makeFlagsArray installCheckFlags installCheckFlagsArray installCheckTarget=installcheck;
            echoCmd 'installcheck flags' "${flagsArray[@]}";
            make ${makefile:+-f $makefile} "${flagsArray[@]}";
            unset flagsArray;
        fi;
    fi;
    runHook postInstallCheck
}
showPhaseHeader ()
{
 
    local phase="$1";
    echo "Running phase: $phase";
    if [[ -z ${NIX_LOG_FD-} ]]; then
        return;
    fi;
    printf "@nix { \"action\": \"setPhase\", \"phase\": \"%s\" }\n" "$phase" >&"$NIX_LOG_FD"
}
_allFlags ()
{
 
    export system pname name version;
    while IFS='' read -r varName; do
        nixTalkativeLog "@${varName}@ -> ${!varName}";
        args+=("--subst-var" "$varName");
    done < <(awk 'BEGIN { for (v in ENVIRON) if (v ~ /^[a-z][a-zA-Z0-9_]*$/) print v }')
}
nixDebugLog ()
{
 
    _nixLogWithLevel 6 "$*"
}
substituteStream ()
{
 
    local var=$1;
    local description=$2;
    shift 2;
    while (( "$#" )); do
        local replace_mode="$1";
        case "$1" in 
            --replace)
                if ! "$_substituteStream_has_warned_replace_deprecation"; then
                    echo "substituteStream() in derivation $name: WARNING: '--replace' is deprecated, use --replace-{fail,warn,quiet}. ($description)" 1>&2;
                    _substituteStream_has_warned_replace_deprecation=true;
                fi;
                replace_mode='--replace-warn'
            ;&
            --replace-quiet | --replace-warn | --replace-fail)
                pattern="$2";
                replacement="$3";
                shift 3;
                if ! [[ "${!var}" == *"$pattern"* ]]; then
                    if [ "$replace_mode" == --replace-warn ]; then
                        printf "substituteStream() in derivation $name: WARNING: pattern %q doesn't match anything in %s\n" "$pattern" "$description" 1>&2;
                    else
                        if [ "$replace_mode" == --replace-fail ]; then
                            printf "substituteStream() in derivation $name: ERROR: pattern %q doesn't match anything in %s\n" "$pattern" "$description" 1>&2;
                            return 1;
                        fi;
                    fi;
                fi;
                eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}'
            ;;
            --subst-var)
                local varName="$2";
                shift 2;
                if ! [[ "$varName" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                    echo "substituteStream() in derivation $name: ERROR: substitution variables must be valid Bash names, \"$varName\" isn't." 1>&2;
                    return 1;
                fi;
                if [ -z ${!varName+x} ]; then
                    echo "substituteStream() in derivation $name: ERROR: variable \$$varName is unset" 1>&2;
                    return 1;
                fi;
                pattern="@$varName@";
                replacement="${!varName}";
                eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}'
            ;;
            --subst-var-by)
                pattern="@$2@";
                replacement="$3";
                eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}';
                shift 3
            ;;
            *)
                echo "substituteStream() in derivation $name: ERROR: Invalid command line argument: $1" 1>&2;
                return 1
            ;;
        esac;
    done;
    printf "%s" "${!var}"
}
isScript ()
{
 
    local fn="$1";
    local fd;
    local magic;
    exec {fd}< "$fn";
    LANG=C read -r -n 2 -u "$fd" magic;
    exec {fd}>&-;
    if [[ "$magic" =~ \#! ]]; then
        return 0;
    else
        return 1;
    fi
}
_doStrip ()
{
 
    local -ra flags=(dontStripHost dontStripTarget);
    local -ra debugDirs=(stripDebugList stripDebugListTarget);
    local -ra allDirs=(stripAllList stripAllListTarget);
    local -ra stripCmds=(STRIP STRIP_FOR_TARGET);
    local -ra ranlibCmds=(RANLIB RANLIB_FOR_TARGET);
    stripDebugList=${stripDebugList[*]:-lib lib32 lib64 libexec bin sbin Applications Library/Frameworks};
    stripDebugListTarget=${stripDebugListTarget[*]:-};
    stripAllList=${stripAllList[*]:-};
    stripAllListTarget=${stripAllListTarget[*]:-};
    local i;
    for i in ${!stripCmds[@]};
    do
        local -n flag="${flags[$i]}";
        local -n debugDirList="${debugDirs[$i]}";
        local -n allDirList="${allDirs[$i]}";
        local -n stripCmd="${stripCmds[$i]}";
        local -n ranlibCmd="${ranlibCmds[$i]}";
        if [[ -n "${dontStrip-}" || -n "${flag-}" ]] || ! type -f "${stripCmd-}" 2> /dev/null 1>&2; then
            continue;
        fi;
        stripDirs "$stripCmd" "$ranlibCmd" "$debugDirList" "${stripDebugFlags[*]:--S -p}";
        stripDirs "$stripCmd" "$ranlibCmd" "$allDirList" "${stripAllFlags[*]:--s -p}";
    done
}
appendToVar ()
{
 
    local -n nameref="$1";
    local useArray type;
    if [ -n "$__structuredAttrs" ]; then
        useArray=true;
    else
        useArray=false;
    fi;
    if type=$(declare -p "$1" 2> /dev/null); then
        case "${type#* }" in 
            -A*)
                echo "appendToVar(): ERROR: trying to use appendToVar on an associative array, use variable+=([\"X\"]=\"Y\") instead." 1>&2;
                return 1
            ;;
            -a*)
                useArray=true
            ;;
            *)
                useArray=false
            ;;
        esac;
    fi;
    shift;
    if $useArray; then
        nameref=(${nameref+"${nameref[@]}"} "$@");
    else
        nameref="${nameref-} $*";
    fi
}
configurePhase ()
{
 
    runHook preConfigure;
    : "${configureScript=}";
    if [[ -z "$configureScript" && -x ./configure ]]; then
        configureScript=./configure;
    fi;
    if [ -z "${dontFixLibtool:-}" ]; then
        export lt_cv_deplibs_check_method="${lt_cv_deplibs_check_method-pass_all}";
        local i;
        find . -iname "ltmain.sh" -print0 | while IFS='' read -r -d '' i; do
            echo "fixing libtool script $i";
            fixLibtool "$i";
        done;
        CONFIGURE_MTIME_REFERENCE=$(mktemp configure.mtime.reference.XXXXXX);
        find . -executable -type f -name configure -exec grep -l 'GNU Libtool is free software; you can redistribute it and/or modify' {} \; -exec touch -r {} "$CONFIGURE_MTIME_REFERENCE" \; -exec sed -i s_/usr/bin/file_file_g {} \; -exec touch -r "$CONFIGURE_MTIME_REFERENCE" {} \;;
        rm -f "$CONFIGURE_MTIME_REFERENCE";
    fi;
    if [[ -z "${dontAddPrefix:-}" && -n "$prefix" ]]; then
        local -r prefixKeyOrDefault="${prefixKey:---prefix=}";
        if [ "${prefixKeyOrDefault: -1}" = " " ]; then
            prependToVar configureFlags "$prefix";
            prependToVar configureFlags "${prefixKeyOrDefault::-1}";
        else
            prependToVar configureFlags "$prefixKeyOrDefault$prefix";
        fi;
    fi;
    if [[ -f "$configureScript" ]]; then
        if [ -z "${dontAddDisableDepTrack:-}" ]; then
            if grep -q dependency-tracking "$configureScript"; then
                prependToVar configureFlags --disable-dependency-tracking;
            fi;
        fi;
        if [ -z "${dontDisableStatic:-}" ]; then
            if grep -q enable-static "$configureScript"; then
                prependToVar configureFlags --disable-static;
            fi;
        fi;
        if [ -z "${dontPatchShebangsInConfigure:-}" ]; then
            patchShebangs --build "$configureScript";
        fi;
    fi;
    if [ -n "$configureScript" ]; then
        local -a flagsArray;
        concatTo flagsArray configureFlags configureFlagsArray;
        echoCmd 'configure flags' "${flagsArray[@]}";
        $configureScript "${flagsArray[@]}";
        unset flagsArray;
    else
        echo "no configure script, doing nothing";
    fi;
    runHook postConfigure
}
substituteAll ()
{
 
    local input="$1";
    local output="$2";
    local -a args=();
    _allFlags;
    substitute "$input" "$output" "${args[@]}"
}
_multioutPropagateDev ()
{
 
    if [ "$(getAllOutputNames)" = "out" ]; then
        return;
    fi;
    local outputFirst;
    for outputFirst in $(getAllOutputNames);
    do
        break;
    done;
    local propagaterOutput="$outputDev";
    if [ -z "$propagaterOutput" ]; then
        propagaterOutput="$outputFirst";
    fi;
    if [ -z "${propagatedBuildOutputs+1}" ]; then
        local po_dirty="$outputBin $outputInclude $outputLib";
        set +o pipefail;
        propagatedBuildOutputs=`echo "$po_dirty"             | tr -s ' ' '\n' | grep -v -F "$propagaterOutput"             | sort -u | tr '\n' ' ' `;
        set -o pipefail;
    fi;
    if [ -z "$propagatedBuildOutputs" ]; then
        return;
    fi;
    mkdir -p "${!propagaterOutput}"/nix-support;
    for output in $propagatedBuildOutputs;
    do
        echo -n " ${!output}" >> "${!propagaterOutput}"/nix-support/propagated-build-inputs;
    done
}
unpackPhase ()
{
 
    runHook preUnpack;
    if [ -z "${srcs:-}" ]; then
        if [ -z "${src:-}" ]; then
            echo 'variable $src or $srcs should point to the source';
            exit 1;
        fi;
        srcs="$src";
    fi;
    local -a srcsArray;
    concatTo srcsArray srcs;
    local dirsBefore="";
    for i in *;
    do
        if [ -d "$i" ]; then
            dirsBefore="$dirsBefore $i ";
        fi;
    done;
    for i in "${srcsArray[@]}";
    do
        unpackFile "$i";
    done;
    : "${sourceRoot=}";
    if [ -n "${setSourceRoot:-}" ]; then
        runOneHook setSourceRoot;
    else
        if [ -z "$sourceRoot" ]; then
            for i in *;
            do
                if [ -d "$i" ]; then
                    case $dirsBefore in 
                        *\ $i\ *)

                        ;;
                        *)
                            if [ -n "$sourceRoot" ]; then
                                echo "unpacker produced multiple directories";
                                exit 1;
                            fi;
                            sourceRoot="$i"
                        ;;
                    esac;
                fi;
            done;
        fi;
    fi;
    if [ -z "$sourceRoot" ]; then
        echo "unpacker appears to have produced no directories";
        exit 1;
    fi;
    echo "source root is $sourceRoot";
    if [ "${dontMakeSourcesWritable:-0}" != 1 ]; then
        chmod -R u+w -- "$sourceRoot";
    fi;
    runHook postUnpack
}
nixInfoLog ()
{
 
    _nixLogWithLevel 3 "$*"
}
runHook ()
{
 
    local hookName="$1";
    shift;
    local hooksSlice="${hookName%Hook}Hooks[@]";
    local hook;
    for hook in "_callImplicitHook 0 $hookName" ${!hooksSlice+"${!hooksSlice}"};
    do
        _logHook "$hookName" "$hook" "$@";
        _eval "$hook" "$@";
    done;
    return 0
}
_defaultUnpack ()
{
 
    local fn="$1";
    local destination;
    if [ -d "$fn" ]; then
        destination="$(stripHash "$fn")";
        if [ -e "$destination" ]; then
            echo "Cannot copy $fn to $destination: destination already exists!";
            echo "Did you specify two \"srcs\" with the same \"name\"?";
            return 1;
        fi;
        cp -r --preserve=timestamps --reflink=auto -- "$fn" "$destination";
    else
        case "$fn" in 
            *.tar.xz | *.tar.lzma | *.txz)
                ( XZ_OPT="--threads=$NIX_BUILD_CORES" xz -d < "$fn";
                true ) | tar xf - --mode=+w --warning=no-timestamp
            ;;
            *.tar | *.tar.* | *.tgz | *.tbz2 | *.tbz)
                tar xf "$fn" --mode=+w --warning=no-timestamp
            ;;
            *)
                return 1
            ;;
        esac;
    fi
}
printLines ()
{
 
    (( "$#" > 0 )) || return 0;
    printf '%s\n' "$@"
}
substituteAllStream ()
{
 
    local -a args=();
    _allFlags;
    substituteStream "$1" "$2" "${args[@]}"
}
echoCmd ()
{
 
    printf "%s:" "$1";
    shift;
    printf ' %q' "$@";
    echo
}
recordPropagatedDependencies ()
{
 
    declare -ra flatVars=(depsBuildBuildPropagated propagatedNativeBuildInputs depsBuildTargetPropagated depsHostHostPropagated propagatedBuildInputs depsTargetTargetPropagated);
    declare -ra flatFiles=("${propagatedBuildDepFiles[@]}" "${propagatedHostDepFiles[@]}" "${propagatedTargetDepFiles[@]}");
    local propagatedInputsIndex;
    for propagatedInputsIndex in "${!flatVars[@]}";
    do
        local propagatedInputsSlice="${flatVars[$propagatedInputsIndex]}[@]";
        local propagatedInputsFile="${flatFiles[$propagatedInputsIndex]}";
        [[ -n "${!propagatedInputsSlice}" ]] || continue;
        mkdir -p "${!outputDev}/nix-support";
        printWords ${!propagatedInputsSlice} > "${!outputDev}/nix-support/$propagatedInputsFile";
    done
}
_makeSymlinksRelative ()
{
 
    local prefixes;
    prefixes=();
    for output in $(getAllOutputNames);
    do
        [ ! -e "${!output}" ] && continue;
        prefixes+=("${!output}");
    done;
    find "${prefixes[@]}" -type l -printf '%H\0%p\0' | xargs -0 -n2 -r -P "$NIX_BUILD_CORES" sh -c '
      output="$1"
      link="$2"

      linkTarget=$(readlink "$link")

      # only touch links that point inside the same output tree
      [[ $linkTarget == "$output"/* ]] || exit 0

      if [ ! -e "$linkTarget" ]; then
        echo "the symlink $link is broken, it points to $linkTarget (which is missing)"
      fi

      echo "making symlink relative: $link"
      ln -snrf "$linkTarget" "$link"
    ' _
}
noBrokenSymlinksInAllOutputs ()
{
 
    if [[ -z ${dontCheckForBrokenSymlinks-} ]]; then
        for output in $(getAllOutputNames);
        do
            noBrokenSymlinks "${!output}";
        done;
    fi
}
moveToOutput ()
{
 
    local patt="$1";
    local dstOut="$2";
    local output;
    for output in $(getAllOutputNames);
    do
        if [ "${!output}" = "$dstOut" ]; then
            continue;
        fi;
        local srcPath;
        for srcPath in "${!output}"/$patt;
        do
            if [ ! -e "$srcPath" ] && [ ! -L "$srcPath" ]; then
                continue;
            fi;
            if [ "$dstOut" = REMOVE ]; then
                echo "Removing $srcPath";
                rm -r "$srcPath";
            else
                local dstPath="$dstOut${srcPath#${!output}}";
                echo "Moving $srcPath to $dstPath";
                if [ -d "$dstPath" ] && [ -d "$srcPath" ]; then
                    rmdir "$srcPath" --ignore-fail-on-non-empty;
                    if [ -d "$srcPath" ]; then
                        mv -t "$dstPath" "$srcPath"/*;
                        rmdir "$srcPath";
                    fi;
                else
                    mkdir -p "$(readlink -m "$dstPath/..")";
                    mv "$srcPath" "$dstPath";
                fi;
            fi;
            local srcParent="$(readlink -m "$srcPath/..")";
            if [ -n "$(find "$srcParent" -maxdepth 0 -type d -empty 2> /dev/null)" ]; then
                echo "Removing empty $srcParent/ and (possibly) its parents";
                rmdir -p --ignore-fail-on-non-empty "$srcParent" 2> /dev/null || true;
            fi;
        done;
    done
}
unpackFile ()
{
 
    curSrc="$1";
    echo "unpacking source archive $curSrc";
    if ! runOneHook unpackCmd "$curSrc"; then
        echo "do not know how to unpack source archive $curSrc";
        exit 1;
    fi
}
getTargetRoleWrapper ()
{
 
    case $targetOffset in 
        -1)
            export NIX_BINTOOLS_WRAPPER_TARGET_BUILD_x86_64_unknown_linux_gnu=1
        ;;
        0)
            export NIX_BINTOOLS_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu=1
        ;;
        1)
            export NIX_BINTOOLS_WRAPPER_TARGET_TARGET_x86_64_unknown_linux_gnu=1
        ;;
        *)
            echo "binutils-wrapper-2.46: used as improper sort of dependency" 1>&2;
            return 1
        ;;
    esac
}
_moveSbin ()
{
 
    if [ "${dontMoveSbin-}" = 1 ]; then
        return;
    fi;
    if [ ! -e "$prefix/sbin" -o -L "$prefix/sbin" ]; then
        return;
    fi;
    echo "moving $prefix/sbin/* to $prefix/bin";
    mkdir -p $prefix/bin;
    shopt -s dotglob;
    for i in $prefix/sbin/*;
    do
        mv "$i" $prefix/bin;
    done;
    shopt -u dotglob;
    rmdir $prefix/sbin;
    ln -s bin $prefix/sbin
}
auditTmpdir ()
{
 
    local dir="$1";
    [ -e "$dir" ] || return 0;
    echo "checking for references to $TMPDIR/ in $dir...";
    local tmpdir elf_fifo script_fifo;
    tmpdir="$(mktemp -d)";
    elf_fifo="$tmpdir/elf";
    script_fifo="$tmpdir/script";
    mkfifo "$elf_fifo" "$script_fifo";
    ( find "$dir" -type f -not -path '*/.build-id/*' -print0 | while IFS= read -r -d '' file; do
        if isELF "$file"; then
            printf '%s\0' "$file" 1>&3;
        else
            if isScript "$file"; then
                filename=${file##*/};
                dir=${file%/*};
                if [ -e "$dir/.$filename-wrapped" ]; then
                    printf '%s\0' "$file" 1>&4;
                fi;
            fi;
        fi;
    done;
    exec 3>&- 4>&- ) 3> "$elf_fifo" 4> "$script_fifo" & ( xargs -0 -r -P "$NIX_BUILD_CORES" -n 1 sh -c '
            if { printf :; patchelf --print-rpath "$1"; } | grep -q -F ":$TMPDIR/"; then
                echo "RPATH of binary $1 contains a forbidden reference to $TMPDIR/"
                exit 1
            fi
        ' _ < "$elf_fifo" ) & local pid_elf=$!;
    local pid_script;
    ( xargs -0 -r -P "$NIX_BUILD_CORES" -n 1 sh -c '
            if grep -q -F "$TMPDIR/" "$1"; then
                echo "wrapper script $1 contains a forbidden reference to $TMPDIR/"
                exit 1
            fi
        ' _ < "$script_fifo" ) & local pid_script=$!;
    wait "$pid_elf" || { 
        echo "Some binaries contain forbidden references to $TMPDIR/. Check the error above!";
        exit 1
    };
    wait "$pid_script" || { 
        echo "Some scripts contain forbidden references to $TMPDIR/. Check the error above!";
        exit 1
    };
    rm -r "$tmpdir"
}
_eval ()
{
 
    if declare -F "$1" > /dev/null 2>&1; then
        "$@";
    else
        eval "$1";
    fi
}
fixLibtool ()
{
 
    local search_path;
    for flag in $NIX_LDFLAGS;
    do
        case $flag in 
            -L*)
                search_path+=" ${flag#-L}"
            ;;
        esac;
    done;
    sed -i "$1" -e "s^eval \(sys_lib_search_path=\).*^\1'${search_path:-}'^" -e 's^eval sys_lib_.+search_path=.*^^'
}
bintoolsWrapper_addLDVars ()
{
 
    local role_post;
    getHostRoleEnvHook;
    if [[ -d "$1/lib64" && ! -L "$1/lib64" ]]; then
        export NIX_LDFLAGS${role_post}+=" -L$1/lib64";
    fi;
    if [[ -d "$1/lib" ]]; then
        local -a glob=($1/lib/lib*);
        if [ "${#glob[*]}" -gt 0 ]; then
            export NIX_LDFLAGS${role_post}+=" -L$1/lib";
        fi;
    fi
}
getTargetRoleEnvHook ()
{
 
    getRole "$depTargetOffset"
}
_addToEnv ()
{
 
    local depHostOffset depTargetOffset;
    local pkg;
    for depHostOffset in "${allPlatOffsets[@]}";
    do
        local hookVar="${pkgHookVarVars[depHostOffset + 1]}";
        local pkgsVar="${pkgAccumVarVars[depHostOffset + 1]}";
        for depTargetOffset in "${allPlatOffsets[@]}";
        do
            (( depHostOffset <= depTargetOffset )) || continue;
            local hookRef="${hookVar}[$depTargetOffset - $depHostOffset]";
            if [[ -z "${strictDeps-}" ]]; then
                local visitedPkgs="";
                for pkg in "${pkgsBuildBuild[@]}" "${pkgsBuildHost[@]}" "${pkgsBuildTarget[@]}" "${pkgsHostHost[@]}" "${pkgsHostTarget[@]}" "${pkgsTargetTarget[@]}";
                do
                    if [[ "$visitedPkgs" = *"$pkg"* ]]; then
                        continue;
                    fi;
                    runHook "${!hookRef}" "$pkg";
                    visitedPkgs+=" $pkg";
                done;
            else
                local pkgsRef="${pkgsVar}[$depTargetOffset - $depHostOffset]";
                local pkgsSlice="${!pkgsRef}[@]";
                for pkg in ${!pkgsSlice+"${!pkgsSlice}"};
                do
                    runHook "${!hookRef}" "$pkg";
                done;
            fi;
        done;
    done
}
nixWarnLog ()
{
 
    _nixLogWithLevel 1 "$*"
}
_multioutDocs ()
{
 
    local REMOVE=REMOVE;
    moveToOutput share/info "${!outputInfo}";
    moveToOutput share/doc "${!outputDoc}";
    moveToOutput share/gtk-doc "${!outputDevdoc}";
    moveToOutput share/devhelp/books "${!outputDevdoc}";
    moveToOutput share/man "${!outputMan}";
    moveToOutput share/man/man3 "${!outputDevman}"
}
addToSearchPath ()
{
 
    addToSearchPathWithCustomDelimiter ":" "$@"
}
noBrokenSymlinks ()
{
 
    local -r output="${1:?}";
    local path;
    local pathParent;
    local symlinkTarget;
    local -i numDanglingSymlinks=0;
    local -i numReflexiveSymlinks=0;
    local -i numUnreadableSymlinks=0;
    if [[ ! -e $output ]]; then
        nixWarnLog "skipping non-existent output $output";
        return 0;
    fi;
    nixInfoLog "running on $output";
    while IFS= read -r -d '' path; do
        pathParent="$(dirname "$path")";
        if ! symlinkTarget="$(readlink "$path")"; then
            nixErrorLog "the symlink $path is unreadable";
            numUnreadableSymlinks+=1;
            continue;
        fi;
        if [[ $symlinkTarget == /* ]]; then
            nixInfoLog "symlink $path points to absolute target $symlinkTarget";
        else
            nixInfoLog "symlink $path points to relative target $symlinkTarget";
            symlinkTarget="$(realpath --no-symlinks --canonicalize-missing "$pathParent/$symlinkTarget")";
        fi;
        if [[ $symlinkTarget = "$TMPDIR"/* ]]; then
            nixErrorLog "the symlink $path points to $TMPDIR directory: $symlinkTarget";
            numDanglingSymlinks+=1;
            continue;
        fi;
        if [[ $symlinkTarget != "$NIX_STORE"/* ]]; then
            nixInfoLog "symlink $path points outside the Nix store; ignoring";
            continue;
        fi;
        if [[ $path == "$symlinkTarget" ]]; then
            nixErrorLog "the symlink $path is reflexive";
            numReflexiveSymlinks+=1;
        else
            if [[ ! -e $symlinkTarget ]]; then
                nixErrorLog "the symlink $path points to a missing target: $symlinkTarget";
                numDanglingSymlinks+=1;
            else
                nixDebugLog "the symlink $path is irreflexive and points to a target which exists";
            fi;
        fi;
    done < <(find "$output" -type l -print0);
    if ((numDanglingSymlinks > 0 || numReflexiveSymlinks > 0 || numUnreadableSymlinks > 0)); then
        nixErrorLog "found $numDanglingSymlinks dangling symlinks, $numReflexiveSymlinks reflexive symlinks and $numUnreadableSymlinks unreadable symlinks";
        exit 1;
    fi;
    return 0
}
prependToVar ()
{
 
    local -n nameref="$1";
    local useArray type;
    if [ -n "$__structuredAttrs" ]; then
        useArray=true;
    else
        useArray=false;
    fi;
    if type=$(declare -p "$1" 2> /dev/null); then
        case "${type#* }" in 
            -A*)
                echo "prependToVar(): ERROR: trying to use prependToVar on an associative array." 1>&2;
                return 1
            ;;
            -a*)
                useArray=true
            ;;
            *)
                useArray=false
            ;;
        esac;
    fi;
    shift;
    if $useArray; then
        nameref=("$@" ${nameref+"${nameref[@]}"});
    else
        nameref="$* ${nameref-}";
    fi
}
printWords ()
{
 
    (( "$#" > 0 )) || return 0;
    printf '%s ' "$@"
}
substitute ()
{
 
    local input="$1";
    local output="$2";
    shift 2;
    if [ ! -f "$input" ]; then
        echo "substitute(): ERROR: file '$input' does not exist" 1>&2;
        return 1;
    fi;
    local content;
    consumeEntire content < "$input";
    if [ -e "$output" ]; then
        chmod +w "$output";
    fi;
    substituteStream content "file '$input'" "$@" > "$output"
}
_logHook ()
{
 
    if [[ -z ${NIX_LOG_FD-} ]]; then
        return;
    fi;
    local hookKind="$1";
    local hookExpr="$2";
    shift 2;
    if declare -F "$hookExpr" > /dev/null 2>&1; then
        nixTalkativeLog "calling '$hookKind' function hook '$hookExpr'" "$@";
    else
        if type -p "$hookExpr" > /dev/null; then
            nixTalkativeLog "sourcing '$hookKind' script hook '$hookExpr'";
        else
            if [[ "$hookExpr" != "_callImplicitHook"* ]]; then
                local exprToOutput;
                if [[ ${NIX_DEBUG:-0} -ge 5 ]]; then
                    exprToOutput="$hookExpr";
                else
                    local hookExprLine;
                    while IFS= read -r hookExprLine; do
                        hookExprLine="${hookExprLine#"${hookExprLine%%[![:space:]]*}"}";
                        if [[ -n "$hookExprLine" ]]; then
                            exprToOutput+="$hookExprLine\\n ";
                        fi;
                    done <<< "$hookExpr";
                    exprToOutput="${exprToOutput%%\\n }";
                fi;
                nixTalkativeLog "evaling '$hookKind' string hook '$exprToOutput'";
            fi;
        fi;
    fi
}
patchELF ()
{
 
    local dir="$1";
    [ -e "$dir" ] || return 0;
    echo "shrinking RPATHs of ELF executables and libraries in $dir";
    local i;
    while IFS= read -r -d '' i; do
        if [[ "$i" =~ .build-id ]]; then
            continue;
        fi;
        if ! isELF "$i"; then
            continue;
        fi;
        echo "shrinking $i";
        patchelf --shrink-rpath "$i" || true;
    done < <(find "$dir" -type f -print0)
}
printPhases ()
{
 
    definePhases;
    local phase;
    for phase in ${phases[*]};
    do
        printf '%s\n' "$phase";
    done
}
runPhase ()
{
 
    local curPhase="$*";
    if [[ "$curPhase" = unpackPhase && -n "${dontUnpack:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = patchPhase && -n "${dontPatch:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = configurePhase && -n "${dontConfigure:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = buildPhase && -n "${dontBuild:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = checkPhase && -z "${doCheck:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = installPhase && -n "${dontInstall:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = fixupPhase && -n "${dontFixup:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = installCheckPhase && -z "${doInstallCheck:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = distPhase && -z "${doDist:-}" ]]; then
        return;
    fi;
    showPhaseHeader "$curPhase";
    dumpVars;
    local startTime endTime;
    startTime=$(date +"%s");
    eval "${!curPhase:-$curPhase}";
    endTime=$(date +"%s");
    showPhaseFooter "$curPhase" "$startTime" "$endTime";
    if [ "$curPhase" = unpackPhase ]; then
        [ -n "${sourceRoot:-}" ] && chmod +x -- "${sourceRoot}";
        cd -- "${sourceRoot:-.}";
    fi
}
patchShebangsAuto ()
{
 
    if [[ -z "${dontPatchShebangs-}" && -e "$prefix" ]]; then
        if [[ "$output" != out && "$output" = "$outputDev" ]]; then
            patchShebangs --build "$prefix";
        else
            patchShebangs --host "$prefix";
        fi;
    fi
}
substituteAllInPlace ()
{
 
    local fileName="$1";
    shift;
    substituteAll "$fileName" "$fileName" "$@"
}
compressManPages ()
{
 
    local dir="$1";
    if [ -L "$dir"/share ] || [ -L "$dir"/share/man ] || [ ! -d "$dir/share/man" ]; then
        return;
    fi;
    echo "gzipping man pages under $dir/share/man/";
    find "$dir"/share/man/ -type f -a '!' -regex '.*\.\(bz2\|gz\|xz\)$' -print0 | xargs -0 -n1 -P "$NIX_BUILD_CORES" gzip -n -f;
    find "$dir"/share/man/ -type l -a '!' -regex '.*\.\(bz2\|gz\|xz\)$' -print0 | sort -z | while IFS= read -r -d '' f; do
        local target;
        target="$(readlink -f "$f")";
        if [ -f "$target".gz ]; then
            ln -sf "$target".gz "$f".gz && rm "$f";
        fi;
    done
}
substituteInPlace ()
{
 
    local -a fileNames=();
    for arg in "$@";
    do
        if [[ "$arg" = "--"* ]]; then
            break;
        fi;
        fileNames+=("$arg");
        shift;
    done;
    if ! [[ "${#fileNames[@]}" -gt 0 ]]; then
        echo "substituteInPlace called without any files to operate on (files must come before options!)" 1>&2;
        return 1;
    fi;
    for file in "${fileNames[@]}";
    do
        substitute "$file" "$file" "$@";
    done
}
updateAutotoolsGnuConfigScriptsPhase ()
{
 
    if [ -n "${dontUpdateAutotoolsGnuConfigScripts-}" ]; then
        return;
    fi;
    for script in config.sub config.guess;
    do
        for f in $(find . -type f -name "$script");
        do
            echo "Updating Autotools / GNU config script to a newer upstream version: $f";
            cp -f "/nix/store/qlpiji0zybs4hl1dw00nfvl60fnlg90j-gnu-config-2024-01-01/$script" "$f";
        done;
    done
}
nixTalkativeLog ()
{
 
    _nixLogWithLevel 4 "$*"
}
PATH="$PATH${nix_saved_PATH:+:$nix_saved_PATH}"
XDG_DATA_DIRS="$XDG_DATA_DIRS${nix_saved_XDG_DATA_DIRS:+:$nix_saved_XDG_DATA_DIRS}"

eval "${shellHook:-}"
shopt -s expand_aliases

exec /tmp/devenv-env9PVuuk/script 