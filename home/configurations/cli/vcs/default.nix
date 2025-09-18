{
  programs = {
    lazygit = {
      enable = true;
      settings = {
        gui = {
          nerdFontsVersion = "3";
     
          customIcons = {
            vcsIcons = {
              branch = "";
              merge-commit = ":)";
              "github.com" = ":(";
            };
            fileIcons = {
              directory = {
                icon = "D";
                color = "#878787";
              };

              file = {
                icon = "F";
                color = "#878787";
              };
            };
          };
        };
        customCommands = [
          {
            key = "E";
            description = "空コミット";
            context = "global";
            command = "git commit --allow-empty -m '{{index .PromptResponses | quote}}'";
            prompts = [
              {
                type = "input";
                title = "Commit message";
                initialValue = "chore: ";
              }
            ];
          }
        ];
      };
    };
  };
}
