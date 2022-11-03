M = {}

M.config = function ()
  require('user.keybindings').set_terminal_keymaps()
end
M.lazygit_toggle = function()
  vim.cmd("FloatermNew --height=10000 --width=10000 --wintype=float --opener=drop lazygit")
end

return M
