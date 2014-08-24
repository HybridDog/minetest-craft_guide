--[[

Craft Guide for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-craft_guide
License: BSD-3-Clause https://raw.github.com/cornernote/minetest-craft_guide/master/LICENSE

MAIN LOADER

]]--

-- load api
dofile(minetest.get_modpath("craft_guide").."/api_craft_guide.lua")

-- register existing recipes
local function tab_to_recipe(x, t)
	local tab
	if x == 1 then
		return {
			{t[1]},
			{t[2]},
			{t[3]}
		}
	end
	if x == 2 then
		return {
			{t[1], t[2]},
			{t[3], t[4]},
			{t[5], t[6]}
		}
	end
	if x == 3 then
		return {
			{t[1], t[2], t[3]},
			{t[4], t[5], t[6]},
			{t[7], t[8], t[9]}
		}
	end
end	

for name,def in pairs(minetest.registered_items) do
	if (not def.groups.not_in_creative_inventory
		or def.groups.not_in_creative_inventory == 0)
	and def.description
	and def.description ~= "" then
		local recipes = minetest.get_all_craft_recipes(name)
		if recipes then
			for _, recipe in ipairs(recipes) do
				local tab = {}
				tab.type = recipe.type
				if tab.type == "normal" then
					tab.type = nil
				end
				tab.output = name

				if not tab.type then
					local x = recipe.width
					if x == 0 then
						x = 3
					end
					tab.recipe = tab_to_recipe(x, recipe.items)
				else
					tab.recipe = recipe.items[1]
				end

				craft_guide.register_craft(tab)
			end
		end
	end
end

-- override minetest.register_craft
local minetest_register_craft = minetest.register_craft
minetest.register_craft = function (options) 
	minetest_register_craft(options) 
	craft_guide.register_craft(options)
end

-- register entities
dofile(minetest.get_modpath("craft_guide").."/register_node.lua")
dofile(minetest.get_modpath("craft_guide").."/register_craft.lua")

-- log that we started
minetest.log("action", "[MOD]"..minetest.get_current_modname().." -- loaded from "..minetest.get_modpath(minetest.get_current_modname()))
