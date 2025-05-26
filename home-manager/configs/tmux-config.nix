{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;
    setClipboard = true; # Corresponds to set -g set-clipboard on
    statusInterval = 5;
    xtermKeys = true; # Handles set-window-option -g xterm-keys on

    extraConfig = ''
      # Status Bar Customization
      set -g status-style bg=default,fg=white
      set -g status-left "#S "
      set -g status-left-length 90
      set -g status-justify absolute-centre
      setw -g window-status-format "#I[#P]"
      setw -g window-status-current-format "#[bold] #W #[nobold]"
      setw -g window-status-current-style fg=black,bg=blue,bold
      set -g status-right "#{?@tpipeline_nvim_ok,#[escape_passthrough]@tpipeline_nvim_status}"
      set -g status-right-length 150

      # For true color if terminal-overrides is still needed
      set-option -sa terminal-overrides ",xterm*:Tc"
    '';

    # Keybindings (prefix-less)
    keybindings = {
      "C-S-t" = "new-window";
      "C-S-q" = "kill-window";
      "C-S-h" = "previous-window";
      "C-S-Left" = "previous-window";
      "C-S-l" = "next-window";
      "C-S-Right" = "next-window";
      "C-M-S-t" = "command-prompt -I \"#W\" \"rename-window -- '%%'\""; # Escaped quotes
      "C-]" = "swap-window -t +1";

      "M-S-Up" = "split-window -v -b";
      "M-S-Down" = "split-window -v";
      "M-S-Left" = "split-window -h -b";
      "M-S-Right" = "split-window -h";

      "M-Up" = "select-pane -U";
      "M-Down" = "select-pane -D";
      "M-Left" = "select-pane -L";
      "M-Right" = "select-pane -R";

      "C-M-Up" = "resize-pane -U 5";
      "C-M-Down" = "resize-pane -D 5";
      "C-M-Left" = "resize-pane -L 5";
      "C-M-Right" = "resize-pane -R 5";

      "M-z" = "resize-pane -Z";
      "M-S-q" = "kill-pane";

      "C-S-s" = "choose-session";
      "C-S-n" = "new-session";
    };
    
    # For prefixed keys (e.g., default prefix Ctrl-b then r)
    bindings = {
        "r" = "source-file ${config.xdg.configHome}/tmux/tmux.conf; display-message \"${config.xdg.configHome}/tmux/tmux.conf reloaded\""; # Escaped quotes
    };

    # Plugin Manager (TPM)
    plugins = with pkgs.tmuxPlugins; [
      tpm # Manages TPM itself
    ];
  };
}
