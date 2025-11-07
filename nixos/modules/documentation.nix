{
  pkgs,
  config,
  lib,
  ...
}:

lib.mkMerge [
  {
    documentation.info.enable = false;
    documentation.nixos.enable = false;

    environment.variables = {
      MANWIDTH = "80";
      MANROFFOPT = "-P -c";
    };
  }

  (
    let
      inherit (pkgs.writers) writeFish;
      cfg = config.documentation.man.man-db;
      cachePath = "/var/cache/man/nixos";
    in
    lib.mkIf (cfg.enable) {
      documentation.man.generateCaches = false;

      systemd.services."man-db" = {
        requires = [ "sysinit-reactivation.target" ];
        after = [ "sysinit-reactivation.target" ];
        partOf = [ "sysinit-reactivation.target" ];
        wantedBy = [ "default.target" ];
        path = [
          cfg.package
          pkgs.gawk
        ];
        serviceConfig = {
          Nice = 19;
          IOSchedulingClass = "idle";
          IOSchedulingPriority = 7;
        };
        serviceConfig.ExecStart = writeFish "mandbsvc" ''
          set -l SystemManLoc "/run/current-system/sw/share/man"
          set -l ContentRecord "${cachePath}/man-db-state"

          if [ ! -d "${cachePath}" ]
              mkdir -pv "${cachePath}" || exit 1
          end

          if [ ! -f "$ContentRecord" ]
              touch "$ContentRecord" || exit 1
          end

          set -l hashes "$(
              find -L "$SystemManLoc" -type f -iname "*.gz" \
                  -exec sha256sum "{}" "+" \
              | awk '{ print $1 }'
              or exit 1
          )"

          set -l ultimate_hash (
              echo $hashes \
              | sort \
              | string join "" \
              | sha256sum - \
              | awk '{ print $1 }'
              or exit 1
          )

          set -l old_hash "$( string collect < "$ContentRecord" )"

          echo "Old hash: $old_hash"
          echo "New hash: $ultimate_hash"

          if [ "$old_hash" != "$ultimate_hash" ]
              echo "Hash changed, do a full man-db rebuild"
              mandb -psc || exit 1
              echo "Write new hash"
              echo "$ultimate_hash" > "$ContentRecord"
          else
              echo "Hash not changed, skip"
          end
        '';
      };

      environment.extraSetup = ''
        find "$out/share/man" \
            -mindepth 1 -maxdepth 1 \
            -not -name "man[1-8]" \
            -exec rm -r "{}" ";"
      '';
    }
  )
]
