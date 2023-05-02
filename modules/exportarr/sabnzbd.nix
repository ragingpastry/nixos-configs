{ config, pkgs, lib, ... }:
let
  cfg = config.services.exportarr.sabnzbd;
  api_key_fragment =
    if cfg.api_key != null
    then "--api-key ${cfg.api_key}"
    else if cfg.api_key_file != null
    then "--api-key-file ${cfg.api_key_file}"
    else throw "Must define either api_key or api_key_file";
  interface = lib.optionalString (cfg.listen_interface != "") "--interface ${cfg.listen_interface}";
in
{
  config = lib.mkIf cfg.enable {
    systemd.services.exportarr_sabnzbd = {
      description = "sabnzbd Exportarr";
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.exportarr}/bin/exportarr sabnzbd --port ${cfg.listen_port} --url ${cfg.url} ${api_key_fragment} ${interface}
      '';
    };
  };
}
