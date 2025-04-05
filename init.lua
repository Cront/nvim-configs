-- Add ~/.config/nvim/lua to package.path
package.path = package.path .. ";/home/smha/.config/nvim/lua/?.lua;/home/smha/.config/nvim/lua/?/init.lua"
require("hasan.core")
require("hasan.lazy")
require("nvim-treesitter.install").prefer_git = true
