{
  programs = {
    lazygit = {
      enable = true;
      settings = {
        customCommands = [
          {
            key = "E";
            description = "空コミット";
            context = "global";
            command = "git commit --allow-empty -m '{{index .PromptResoinses 0}}'";
            prompts = [
              {
                type = "input";
                title = "Commit message";
                initialValue = "chore: empty commit";
              }
            ];
          }
        ];
      };
    };
  };
}
