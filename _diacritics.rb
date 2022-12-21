#!/usr/bin/env ruby

require 'csv'
require 'byebug'

BREVE = 0
MACRON = 1

def diacritify(word)
	# find second-last syllable
end
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
	next if verse['text'] != verse['textdiacritics']

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
		prevs << i if tokens[i] == tokens[last]
		i += 1	
	end
	next if prevs.count != 1

	term = tokens[last]
	syllables = term.split(/([^aeiouyAEIOUY]+[aeiouyAEIOUY])/).reject { |c| c.empty? }
	penult = (syllables.last.match?(/.*[aeiouyAEIOUY]$/)) ? syllables.count - 2 : syllables.count - 3
	vowel = syllables[penult].scan(/[aeiouyAEIOUY]/).first
	original_syllable = syllables[penult].dup

	syllables[penult] = original_syllable.sub(vowel, conversions[vowel][BREVE])
	tokens[prevs.first] = syllables.join
	syllables[penult] = original_syllable.sub(vowel, conversions[vowel][MACRON])
	tokens[last] = syllables.join

	verse['textdiacritics'] = tokens.join
end

changed = 0
unchanged = 0
data.each do |verse|
	if verse['text'] == verse['textdiacritics']
		unchanged += 1
	else
		changed += 1
	end
end
puts "Unchanged: #{unchanged}; changed: #{changed}"

CSV.open("newdata.csv", "w") do |csv|
  csv << data.headers
  data.each do |verse|
    csv << verse
  end
end