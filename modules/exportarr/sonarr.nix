{ config, pkgs, lib, ... }:
let
  cfg = config.services.exportarr.sonarr;
  api_key_fragment =
    if cfg.api_key != ""
    then "--api-key ${cfg.api_key}"
    else if cfg.api_key_file != null
    then "--api-key-file ${cfg.api_key_file}"
    else if cfg.config != null
    then "--config ${cfg.config}"
    else throw "Must define either api_key or api_key_file or config";
  interface = lib.optionalString (cfg.listen_interface != "") "--interface ${cfg.listen_interface}";
in
{
  config = lib.mkIf cfg.enable {
    systemd.services.exportarr_sonarr = {
      description = "sonarr Exportarr";
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.exportarr}/bin/exportarr sonarr --port ${cfg.listen_port} --url ${cfg.url} ${api_key_fragment} ${interface}
      '';
    };
  };
}
