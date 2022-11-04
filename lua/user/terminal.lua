M = {}

M.config = function ()
  require('user.keybindings').set_terminal_keymaps()
end

M.lazygit_toggle = function()
  local config_file = ""
  if vim.o.background == "dark" then
    config_file = " --ucf ~/.config/lazygit/config_dark.yml"
  end
  vim.cmd("FloatermNew --height=10000 --width=10000 --wintype=float --opener=drop lazygit" .. config_file)
end

return M
