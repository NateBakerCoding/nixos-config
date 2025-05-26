{ config, pkgs, ... }:

{
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;

    # Switch to WirePlumber session manager
    wireplumber.enable = true;
  };

  # Set real-time priorities for PipeWire to ensure low-latency operation
  systemd.services.pipewire.serviceConfig = {
    CPUAccounting = true;
    IOAccounting = true;
    MemoryAccounting = true;
    CPUWeight = 500;
    IOWeight = 500;
    MemoryHigh = "1G";
  };

  # Recommended for low-latency performance
  environment.variables = {
    PIPEWIRE_LATENCY = "256/48000"; # Example latency setting for low-latency audio
  };
}

