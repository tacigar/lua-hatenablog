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

local oauth = require 'OAuth'

io.write 'consumer key? > '
local consumer_key = io.read()
io.write 'consumer secret? > '
local consumer_secret = io.read()

local client = oauth.new(consumer_key, consumer_secret, {
	RequestToken = "https://www.hatena.com/oauth/initiate",
	AccessToken = "https://www.hatena.com/oauth/token",
	AuthorizeUser = {
		"https://www.hatena.ne.jp/oauth/authorize",
		method = "GET",
	},
})

local callback_url = "oob"
local values = client:RequestToken({
	oauth_callback = callback_url,
	scope = "read_public,write_public,read_private,write_private",
})

local oauth_token = values.oauth_token
local oauth_token_secret = values.oauth_token_secret

local tracking_code = "114514"
local new_url = client:BuildAuthorizationUrl({
	oauth_callback = callback_url,
	state = tracking_code
})

print("Navigate to this url with your browser, please...")
print(new_url)
io.write("\r\nOnce you have logged in and authorized the application, enter the PIN > ")

local oauth_verifier = io.read()

client = oauth.new(consumer_key, consumer_secret, {
	RequestToken = "https://www.hatena.com/oauth/initiate",
	AccessToken = "https://www.hatena.com/oauth/token",
	AuthorizeUser = {
		"https://www.hatena.ne.jp/oauth/authorize",
		method = "GET",
	},
}, {
	OAuthToken = oauth_token,
	OAuthVerifier = oauth_verifier,
})

client:SetTokenSecret(oauth_token_secret)

values = client:GetAccessToken()
for key, val in pairs(values) do
	print(key, val)
end
