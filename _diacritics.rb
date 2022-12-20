#!/usr/bin/env ruby

require 'csv'
require 'byebug'

data = CSV.read('_data/versdiff.csv', headers: true)

conversions = {
	"a"=>["ă", "ā"], 
	"e"=>["ĕ", "ē"], 
	"i"=>["ĭ", "ī"], 
	"o"=>["ŏ", "ō"], 
	"u"=>["ŭ", "ū"], 
	"y"=>["y", "ȳ"], 
	"A"=>["Ă", "Ā"], 
	"E"=>["Ĕ", "Ē"], 
	"I"=>["Ĭ", "Ī"], 
	"O"=>["Ŏ", "Ō"], 
	"U"=>["Ŭ", "Ū"], 
	"Y"=>["Y", "Ȳ"]
}

data.each do |verse|
	text = verse['text']
	next if text.include?('/') # skip multiple-line verses

	tokens = text.strip.split(/(\W)/,-1) # includes words, spaces, and punctuation
	last = tokens.count - 1
	while (!tokens[last].match?(/\w+/)) do 
		last -= 1
	end

	prevs = []
	i = 0
	while (i < last) do
		prevs << tokens[i] if tokens[i] == tokens[last]
		i += 1	
	end
	byebug
end