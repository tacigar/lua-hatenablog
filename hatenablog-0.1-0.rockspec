package = "hatenablog"
version = "0.1-0"

source = {
	url = "git://github.com/tacigar/lua-hatenablog",
	tag = "v0.1",
}

description = {
	summary = "A Hatena BLOG AtomPub API Client",
	detailed = [[
	  This library provides Hatena BLOG AtomPub APIs.
	  You can post, update, delete and view articles of Hatena Blog.
	]],
	homepage = "https://github.com/tacigar/lua-hatenablog",
	license = "GPLv3",
}

dependencies = {
	"lua >= 5.1",
	"xml",
	"lub",
	"oauth",
}

build = {
	type = "builtin",
	modules = {
		["hatenablog"] = "hatenablog/init.lua",
		["hatenablog.categories"] = "hatenablog/categories.lua",
		["hatenablog.client"] = "hatenablog/client.lua",
		["hatenablog.entry"] = "hatenablog/entry.lua",
		["hatenablog.feed"] = "hatenablog/feed.lua",
		["hatenablog.util"] = "hatenablog/util.lua",
	},
	install = {
		bin = { "bin/hatenablog_token" },
	}
}
