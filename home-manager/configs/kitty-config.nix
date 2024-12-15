{ config, pkgs, ... }:

{
  # Ensure Kitty is installed
  home.packages = with pkgs; [ kitty ];

  # Enable Kitty terminal and configure settings
  programs.kitty.enable = true;

  programs.kitty.settings = {
    font_family = "BitstromWera Nerd Font Mono";
    bold_font = "BitstromWera Nerd Font Mono Bold";
    italic_font = "BitstromWera Nerd Font Mono Oblique";
    bold_italic_font = "BitstromWera Nerd Font Mono Bold Oblique";
    font_size = 28.0;
    sync_to_monitor = true;
    remember_window_size = true;
    initial_window_width = "1280";
    initial_window_height = "720";
    draw_minimal_borders = true;

    # Tab Bar
    tab_bar_edge = "top";
    tab_bar_style = "powerline";
    tab_powerline_style = "round";
    tab_activity_symbol = "Δ";
    tab_title_template = "{activity_symbol}{index}: {title}";
    active_tab_title_template = "{index}: {title}";
    tab_bar_align = "left";
    tab_bar_min_tabs = 1;
    tab_switch_strategy = "left";
    tab_bar_margin_height = " 0.0 5.0 ";

    # Clipboard
    clipboard_control = "write-clipboard write-primary read-clipboard-ask read-primary-ask";
    clipboard_max_size = 512;

    # Misc
    allow_hyperlinks = true;
    wayland_titlebar_color = "system";
    allow_remote_control = true;
    listen_on = "unix:/tmp/kitty.sock";
    prestore_windows = "none";

    # Background
    background_image = "path_to_image";
    background_opacity = 0.75;
    background_image_layout = "scaled";
  };

  # Add startup_session file
  home.file.".config/kitty/kitty-start".text = ''
    # This file will hold the kitty startup info

    # Main Tab
    launch --title "Main"

    os_window_state fullscreen
  '';
}

