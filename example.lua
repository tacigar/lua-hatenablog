package.path = "./src/?.lua;"..package.path

local hatena = require 'hatenablog'

local client = hatena.Client.new {
	user_id = "<user_id>",
	blog_id = "<blog_id>",
	consumer_key = "<consumer_key>",
	consumer_secret = "<consumer_secret>",
	access_token = "<access_token>",
	access_token_secret = "<access_token_secret>",
}

local entry1 = client:post_entry {
	title = 'エントリー１',
	content = [[
* トンカツ！
* マック！
* ブーグー！！
]],
	categories = {'名言'},
	draft = 'yes',
}

local entry2 = client:post_entry {
	title = 'エントリー２',
	content = [[
* イッポン！
* ザクロ！
* ニャオ！！
]],
	categories = {'迷言'},
	draft = 'yes',
}

client:update_entry(entry2.id, {
	title = entry2.title,
	content = [[
* センボン！
* ザクラ！
* ビャオ！！
]],
	categories = {'名言', 'カラオケ'},
	draft = 'yes',
})

for entry in client:entries() do
	print('id: ', entry.id)
	print('uri: ', entry.uri)
	print('edit_uri: ', entry.edit_uri)
	print('author_name: ', entry.author_name)
	print('title: ', entry.title)
	print('content: ', entry.content)
	print('draft: ', entry.draft)
	print('updated: ', entry.updated)
	for i, category in ipairs(entry.categories) do
		print(string.format('categories[%d]: %s', i, category))
	end
end

print '------------------------------'

client:delete_entry(entry1.id)
client:delete_entry(entry2.id)
