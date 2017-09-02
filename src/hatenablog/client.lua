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

local OAuth = require 'OAuth'
local Entry = require 'hatenablog.entry'
local Feed = require 'hatenablog.feed'
local Categories = require 'hatenablog.categories'

_M.Client = {}
_M.Client.__index = _M.Client

function _M.new(config)
	local function err(key)
		error(string.format('config must contains %s', key))
	end
	local new_client = {
		user_id = config.user_id or err 'user_id',
		blog_id = config.blog_id or err 'blog_id',
		consumer_key = config.consumer_key or err 'consumer_key',
		consumer_secret = config.consumer_secret or err 'consumer_secret',
		access_token = config.access_token or err 'access_token',
		access_token_secret = config.access_token_secret or 'access_token_secret',
	}

	new_client.oauth_client = OAuth.new(new_client.consumer_key, new_client.consumer_secret, {}, {
		OAuthToken = new_client.access_token,
		OAuthTokenSecret = new_client.access_token_secret,
	})
	return setmetatable(new_client, _M.Client)
end

local BASE_SERVICE_URI = "https://blog.hatena.ne.jp/%s/%s/atom"
local BASE_ENTRY_URI = "https://blog.hatena.ne.jp/%s/%s/atom/entry/%s"
local BASE_COLLECTION_URI = "https://blog.hatena.ne.jp/%s/%s/atom/entry"
local BASE_CATEGORY_URI = "https://blog.hatena.ne.jp/%s/%s/atom/category"

function _M.Client:service_uri()
	return string.format(BASE_SERVICE_URI, self.user_id, self.blog_id)
end

function _M.Client:entry_uri(entry_id)
	return string.format(BASE_ENTRY_URI, self.user_id, self.blog_id, entry_id)
end

function _M.Client:collection_uri(page_number)
	if type(page_number) == number then
		return string.format(BASE_COLLECTION_URI, self.user_id, self.blog_id)..'?page='..tostring(page_number)
	else
		return string.format(BASE_COLLECTION_URI, self.user_id, self.blog_id)
	end
end

function _M.Client:category_uri()
	return string.format(BASE_CATEGORY_URI, self.user_id, self.blog_id)
end

function _M.Client:get_entry(entry_id)
	local _, _, _, body = self.oauth_client:PerformRequest('GET', self:entry_uri(entry_id))
	return Entry.load_xml(body)
end

function _M.Client:get_collection(page_number)
	local _, _, _, body = self.oauth_client:PerformRequest('GET', self:collection_uri(page_number))
	return Feed.load_xml(body)
end

function _M.Client:post_entry(args)
	args.author_name = self.user_id
	local entry_xml = Entry.build_xml(args)
	local _, _, _, body = self.oauth_client:PerformRequest('POST', self:collection_uri(), entry_xml)
	return Entry.load_xml(body)
end

function _M.Client:update_entry(entry_id, args)
	args.author_name = self.user_id
	local entry_xml = Entry.build_xml(args)
	local _, _, _, body = self.oauth_client:PerformRequest('PUT', self:entry_uri(entry_id))
	return Entry.load_xml(body)
end

function _M.Client:delete_entry(entry_id)
	self.oauth_client:PerformRequest('DELETE', self:entry_uri(entry_id))
end

function _M.Client:next_feed(feed)
	if not feed.next_uri then
		return nil
	end
	local _, _, _, body = self.oauth_client:PerformRequest('GET', feed.next_uri)
	return Feed.load_xml(body)
end

function _M.Client:entries(entry, start_page)
	local entry_index = 1
	local current_feed = self:get_collection(start_page)

	return function()
		if entry_index > #(current_feed.entries) then
			if not current_feed:has_next() then
				return nil
			else
				current_feed = self:next_feed(current_feed)
				entry_index = 1
			end
		end
		local res = current_feed.entries[entry_index]
		entry_index = entry_index + 1
		return res
	end
end

function _M.Client:categories()
	local _, _, _, body = self.oauth_client:PerformRequest('GET', self:category_uri())
	return Categories.load_xml(body)
end

return _M
