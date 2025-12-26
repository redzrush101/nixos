{ config, pkgs, ... }:

{
  # Wifi driver
  boot.extraModulePackages = [ config.boot.kernelPackages.rtl88x2bu ];
  boot.blacklistedKernelModules = [ "rtw88_8822bu" ];
  boot.extraModprobeConfig = ''
    options 88x2bu rtw_switch_usb_mode=1 rtw_power_mgnt=0 rtw_ips_mode=0 rtw_enusbss=0 rtw_beamforming_enable=0 rtw_vht_enable=2 rtw_stbc_enable=0
  '';
}
