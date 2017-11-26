#!/usr/bin/env ruby
require 'json'
require 'date'
FILE = '~/.config/google-chrome/Default/Bookmarks'
CJK  = /\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/

def build parent, json
	name = [parent, json['name']].compact.join('/').gsub('//','/')
	if json['type'] == 'folder'
		json['children'].map { |child| build name, child }
	else
		if name.end_with? "/"
			name = "EMPTY"
		end
		# TODO: Add date_last_visited
		{ date_added: json['date_added'], name: name, url: json['url'] }
	end
end

def just str, width
    str.ljust(width - str.scan(CJK).length)
end

def trim str, width
	len = 0
	str.each_char.each_with_index do |char, idx|
		len += char =~ CJK ? 2 : 1
		return str[0, idx] if len > width
	end
	str
end

def cdate2ldate date
	return DateTime.strptime(((date.to_i/1000000)-11644473600).to_s,'%s').strftime("%F %T")
end

width = `tput cols`.strip.to_i / 3
json  = JSON.load File.read File.expand_path FILE
items = json['roots']
	.values_at(*%w(bookmark_bar synced other))
	.compact
	.map { |e| build nil, e }
	.flatten

items.each do |item|
	name = trim(item[:name]
		.sub('Bookmarks bar', 'BMB')
		.sub('Mobile bookmarks', 'MB')
		.sub('Other bookmarks', 'OB'),
	width)
	date_added = cdate2ldate(item[:date_added])
	date_visited = cdate2ldate item[:last_visited_desktop]
	puts [
		date_added,
		# date_visited,
		just(name, width),
		item[:url]
	].join("\t\x1b[33m") + "\x1b[m"
end
