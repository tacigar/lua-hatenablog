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
local Util = require 'hatenablog.util'

_M.Entry = {}
_M.Entry.__index = _M.Entry

function _M.load_xml(xml)
	local data = Xml.load(xml)
	local new_entry = {}

	new_entry.uri = Xml.find(data, 'link', 'rel', 'alternate').href
	new_entry.edit_uri = Xml.find(data, 'link', 'rel', 'edit').href
	new_entry.author_name =	Xml.find(Xml.find(data, 'author'), 'name')[1]
	new_entry.title = Xml.find(data, 'title')[1]
	new_entry.content = Xml.find(data, 'content')[1]
	new_entry.draft = Xml.find(Xml.find(data, 'app:control'), 'app:draft')[1]
	new_entry.updated = Xml.find(data, 'updated')[1]

	new_entry.categories = {}
	Lub.search(data, function(node)
		if node.xml == 'category' then
			table.insert(new_entry.categories, node.term)
		end
	end)

	local segs = Util.split_string(new_entry.edit_uri, '/')
	new_entry.id = segs[#segs]

	return setmetatable(new_entry, _M.Entry)
end

function _M.build_xml(args)
	local title = args.title or ''
	local author_name = args.author_name or ''
	local content = args.content or ''
	local categories = {}
	local draft = args.draft or 'no'
	local updated = nil

	local xml_data = { xml = 'entry',
		['xmlns'] = 'http://www.w3.org/2005/Atom',
		['xmlns:app'] = 'http://www.w3.org/2007/app',
		{ xml = 'title', title },
		{ xml = 'author', { xml = 'name', author_name } },
		{ xml = 'content', type = 'text/x-markdown', content},
		{ xml = 'app:control', { xml = 'app:draft', draft }},
	}
	if type(args.categories) == 'table' and next(args.categories) then
		for _, category in ipairs(categories) do
			table.insert(xml_data, { xml = 'category', term = category})
		end
	end
	if args.updated then
		table.insert(xml_data, { xml = 'updated', args.updated })
	end

	return '<?xml version="1.0" encoding="utf-8"?>\n'..Xml.dump(xml_data)
end

return _M
