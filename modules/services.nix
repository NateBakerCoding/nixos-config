{ configs, pkgs, ...}:


{
    services.logind.lidSwitch = "ignore";
    
    services.ollama = {
        enable = true;
        acceleration = "cuda";
    };


}


