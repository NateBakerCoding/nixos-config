final: prev: {
  vimPlugins = prev.vimPlugins // {
    vim-moonfly-colors = prev.vimUtils.buildVimPlugin {
      pname = "vim-moonfly-colors";
      version = "2024-03-13";
      src = prev.fetchFromGitHub {
        owner = "bluz71";
        repo = "vim-moonfly-colors";
        rev = "7c639fa4201148a3453cf885f261713b0a660712";
        sha256 = "sha256-oD4K/V7y3zQK1Tqi6Y4Cnr51Am8IQzOy4X9SU4fYlW4="; 
      };
    };
  };
}
