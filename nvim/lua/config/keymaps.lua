-- commenting
-- vim.keymap.set("i", "<C-S-_>", function()
--   require("Comment.api").call("toggle.linewise.current", "g@")
-- end, { remap = true, silent = true })
-- vim.keymap.set("n", "<C-S-_>", function()
--   require("Comment.api").call("comment.linewise.current", "g@")
-- end, { remap = true, silent = true })

local frcpal = require("frcpal")

vim.keymap.set("n", "<leader>pb", function()
  frcpal.gradle("build")
end, { desc = "build" }) -- pb for Project Build
vim.keymap.set("n", "<leader>pd", function()
  frcpal.gradle("deploy")
end, { desc = "deploy" }) -- pd for Project Deploy
vim.keymap.set("n", "<leader>pD", frcpal.get_vendorde, { desc = "vendordep" }) -- pD for Project Dependencies
