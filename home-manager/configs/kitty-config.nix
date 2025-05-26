{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      # Assuming "BitstromWera Nerd Font Mono" is available system-wide or via another nix expression.
      # If not, a specific package might be needed, e.g.:
      # package = pkgs.nerdfonts.override { fonts = [ "BitstreamVeraNerds" ]; };
      # For now, we rely on the font name being resolvable by Kitty if installed.
      name = "BitstromWera Nerd Font Mono";
      size = 28.0;
    };
    settings = {
      # Font settings (bold, italic, bold-italic)
      bold_font = "BitstromWera Nerd Font Mono Bold";
      italic_font = "BitstromWera Nerd Font Mono Oblique";
      bold_italic_font = "BitstromWera Nerd Font Mono Bold Oblique";

      # Performance and Display
      sync_to_monitor = true;

      # Window Behavior
      remember_window_size = true;
      initial_window_width = 2560; # Numeric
      initial_window_height = 1440; # Numeric
      draw_minimal_borders = true;
      hide_window_decorations = "no"; # Explicitly set, though 'no' is often default

      # Tab Bar - Hidden
      tab_bar_edge = "hidden"; # This is the key to hide the tab bar

      # Clipboard
      clipboard_control = "write-clipboard write-primary read-clipboard-ask read-primary-ask";
      clipboard_max_size = 512; # In MiB

      # Links
      allow_hyperlinks = true;

      # Wayland Specific
      wayland_titlebar_color = "system";

      # Remote Control
      allow_remote_control = true;
      listen_on = "unix:/tmp/kitty.sock"; # Ensure this path is appropriate

      # Session
      prestore_windows = "none"; # Or "last-used" or "always"
      startup_session = "${config.home.homeDirectory}/.config/kitty/kitty-start"; # Points to the managed startup file

      # Background Image
      background_image = "${config.home.homeDirectory}/.config/kitty/background_image.png";
      background_opacity = 0.86;
      background_image_layout = "scaled"; # Or "tiled", "mirror-tiled", "stretched", "centered"

      # Shell Integration
      shell_integration = "no-sudo"; # Disables sudo integration for security
    };

    keybindings = {
      "f1" = "clear_terminal scroll active";
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "f5" = "load_config_file"; # Reloads HM-generated kitty.conf
      "ctrl+shift+equal" = "change_font_size all +2.0";
      "ctrl+shift+plus" = "change_font_size all +2.0"; # Alias for equal
      "ctrl+shift+kp_add" = "change_font_size all +2.0"; # Alias for equal
      "ctrl+shift+minus" = "change_font_size all -2.0";
      "ctrl+shift+kp_subtract" = "change_font_size all -2.0"; # Alias for minus
    };
    # configFile = null; # This would clear all default keybindings not set above.
                         # programs.kitty.keybindings replaces defaults, so this is typically not needed.
  };

  # Manage the background image file placeholder
  home.file.".config/kitty/background_image.png" = {
    text = "# This is a placeholder. Put your background_image.png in ~/.config/kitty/ or update home-manager to source it from your Nix config directory (e.g., source = ./assets/kitty_background.png;).";
    # To use a fetched image (requires internet during build and correct SHA256):
    # source = pkgs.fetchurl {
    #   url = "https://raw.githubusercontent.com/catppuccin/wallpapers/main/landscapes/NaturePath.png";
    #   sha256 = "1133aaw5v3599v7q79m7z3s2c97j8g7zvygw7x7h0j8g9g5f8m28"; # Replace with actual SHA256
    # };
    executable = false; # Ensure it's not executable
  };

  # Manage the startup session file (content from existing Nix config)
  home.file.".config/kitty/kitty-start" = {
    text = ''
      # This file will hold the kitty startup info

      # Main Tab
      launch --title "Main"

      os_window_state fullscreen
    '';
    executable = false; # Ensure it's not executable
  };

  # Ensure kitty package is installed
  home.packages = with pkgs; [ kitty ];
}
