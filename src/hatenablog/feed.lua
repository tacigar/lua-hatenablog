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
local Entry = require 'hatenablog.entry'

_M.Feed = {}
_M.Feed.__index = _M.Feed

function _M.load_xml(xml)
	local data = Xml.load(xml)
	local new_feed = {}

	new_feed.uri = Xml.find(data, 'link', 'rel', 'alternate').href
	new_feed.title = Xml.find(data, 'title')[1]
	new_feed.author_name = Xml.find(Xml.find(data, 'author'), 'name')[1]
	new_feed.updated = Xml.find(data, 'updated')[1]

	local next_uri = Xml.find(data, 'link', 'rel', 'next')
	if next_uri then
		new_feed.next_uri = next_uri.href
	end

	new_feed.entries = {}
	Lub.search(data, function(node)
		if node.xml == 'entry' then
			local new_entry = Entry.load_xml(Xml.dump(node))
			table.insert(new_feed.entries, new_entry)
		end
	end)

	return setmetatable(new_feed, _M.Feed)
end

function _M.Feed:has_next()
	return self.next_uri ~= nil
end

return _M
