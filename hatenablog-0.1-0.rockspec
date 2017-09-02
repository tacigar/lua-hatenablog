package = "hatenablog"
version = "0.1-0"
source = {
	url = "git://github.com/tacigar/lua-hatenablog",
}
description = {
	summary = "A Hatena BLOG AtomPub API Client",
	detailed = "A Hatena BLOG AtomPub API Client",
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
		hatenablog = "src/hatenablog.lua",
		["hatenablog.categories"] = "src/hatenablog/categories.lua",
		["hatenablog.client"] = "src/hatenablog/client.lua",
		["hatenablog.entry"] = "src/hatenablog/entry.lua",
		["hatenablog.feed"] = "src/hatenablog/feed.lua",
		["hatenablog.util"] = "src/hatenablog/util.lua",
	}
}
