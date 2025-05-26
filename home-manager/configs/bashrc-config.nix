{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true; # Handles bash completion setup
    enableDircolors = true;  # Handles dircolors evaluation and availability
    shellOptions = [ "checkwinsize" ];

    shellAliases = {
      exa = "eza";
      ll = "eza -al";
      la = "eza -a";
      l = "eza -F";
      ls = "eza --color=auto -al --icons";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      diff = "diff --color=auto";
    };

    promptInit = ''
      # PROMPT SETUP (Catppuccin Mocha)
      prompt_cmd() {
          local RESET="\[\e[0m\]" # Escaped for Nix string

          # Colors (Catppuccin Mocha)
          local COLOR_USER="\[\e[38;2;137;180;250m\]"    # Blue
          local COLOR_PATH="\[\e[38;2;249;226;175m\]"    # Yellow
          local COLOR_GIT="\[\e[38;2;203;166;247m\]"     # Mauve (purple)
          local COLOR_TIME="\[\e[38;2;166;173;200m\]"    # Subtle gray-blue
          local COLOR_STATUS_OK="\[\e[38;2;166;227;161m\]"   # Green
          local COLOR_STATUS_ERR="\[\e[38;2;243;139;168m\]"  # Red
          local COLOR_ARROW="\[\e[38;2;137;180;250m\]"       # Blue arrows
          local COLOR_LAMBDA="\[\e[38;2;166;227;161m\]"  # Green lambda always

          # Symbols
          local ARROW="➜"
          local GIT_ICON="" # Make sure your terminal font supports this character

          # Git branch detection
          local branch=""
          if command -v git &>/dev/null; then
              branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
          fi

          # Time
          local current_time
          current_time=$(date +%H:%M)

          # Exit status
          local last_exit="$?"
          local status_display=""
          if [[ $last_exit -ne 0 ]]; then
              status_display="${COLOR_STATUS_ERR}[exit $last_exit]${RESET}"
          fi

          # Set window title (uses \w for full tilde-abbreviated path, which is common for titles)
          PS1="\[\e]0;\u@\h: \w\a\]"

          # --- First Line ---
          PS1+="${COLOR_TIME}[${current_time}]${RESET}"   # [HH:MM]
          PS1+=" ${COLOR_ARROW}${ARROW}${RESET}"          # time arrow user
          PS1+=" ${COLOR_USER}[${USER}]${RESET}"           # [user]
          # Using \W directly for the path basename
          PS1+=" ${COLOR_ARROW}${ARROW}${RESET} ${COLOR_PATH}[\W]${RESET}"  # [path basename]

          if [[ -n "$branch" ]]; then
              PS1+=" ${COLOR_GIT}[${GIT_ICON} ${branch}]${RESET}"  # [ branch]
          fi

          if [[ -n "$status_display" ]]; then
              PS1+=" ${status_display}"  # [exit code] if exists
          fi

          PS1+="
" # Newline for the second line of the prompt

          # --- Second Line ---
          PS1+="${COLOR_ARROW}╰─${RESET} ${COLOR_LAMBDA}λ${RESET} "
      }
      PROMPT_COMMAND=prompt_cmd
    '';

    initExtra = ''
      # Lesspipe
      # Ensures lesspipe is evaluated if present; less needs to be in home.packages
      if [ -x /usr/bin/lesspipe ]; then
        eval "$(SHELL=/bin/sh lesspipe)"
      fi

      # Load user aliases, if the file exists
      [ -f ~/.bash_aliases ] && . ~/.bash_aliases

      # Cargo environment setup, if the file exists
      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

      # update_nixconfig function
      update_nixconfig(){
          # Navigate to the NixOS configuration directory
          # Using a variable for the path might be more flexible if needed later
          local nix_config_dir="$HOME/nixos-config" 
          cd "$nix_config_dir" || { echo "Error: Could not cd to $nix_config_dir"; return 1; }


          # Stage all changes
          git add .

          # Commit changes with the current date in the message
          current_date=$(date "+%b %d %Y")
          git commit -m "$current_date"

          # Rebuild NixOS with the specified flake
          # Ensure this command is appropriate for your setup
          sudo nixos-rebuild switch --flake "$nix_config_dir#bakerdev"
      }

      # Source blesh for enhanced command line editing
      # Check if running in an interactive shell (PS1 is set) and blesh script exists
      if [ -n "$PS1" ] && [ -s "${pkgs.blesh}/share/blesh/ble.sh" ]; then
        source "${pkgs.blesh}/share/blesh/ble.sh"
      fi
    '';
  };

  home.packages = with pkgs; [
    blesh # For advanced shell features
    less  # For lesspipe functionality
    eza   # For the 'exa' aliases
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Add $HOME/.local/bin to PATH
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
