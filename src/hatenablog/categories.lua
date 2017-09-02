---------------------------------------------------------------------
-- lua-hatenablog
-- Copyright (C) 2017 tacigar
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
---------------------------------------------------------------------

local _M = {}

local Xml = require 'xml'
local Lub = require 'lub'

_M.Categories = {}
_M.Categories.__index = _M.Categories

function _M.load_xml(xml)
	local data = Xml.load(xml)
	local new_categories = {}
	Lub.search(data, function(node)
		if node.xml == 'atom:category' then
			table.insert(new_categories, node.term)
		end
	end)
	return setmetatable(new_categories, _M.Categories)
end

return _M
