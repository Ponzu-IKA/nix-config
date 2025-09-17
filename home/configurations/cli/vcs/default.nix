{
  programs = {
    lazygit = {
      enable = true;
      settings = {
        gui = {
          showIcons = true;
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
