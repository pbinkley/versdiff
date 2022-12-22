#!/usr/bin/env ruby

require 'csv'
require 'byebug'

BREVE = 0
MACRON = 1

CONVERSIONS = {
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

def diacritify(term, diacritic)
	syllables = ('|' + term).split(/([^aeiouyAEIOUY]+[aeiouyAEIOUY])/).reject { |c| c.empty? }
	penult = (syllables.last.match?(/.*[aeiouyAEIOUY]$/)) ? syllables.count - 2 : syllables.count - 3
	vowel = syllables[penult].scan(/[aeiouyAEIOUY]/).first
	if vowel
		original_syllable = syllables[penult].dup
		syllables[penult] = original_syllable.sub(vowel, CONVERSIONS[vowel][diacritic])
		syllables.join[1..-1] # return diacritified term, removing the first char (|)
	end
end

data = CSV.read('_data/versdiff.csv', headers: true)

data.each do |verse|
	next if verse['text'] != verse['textdiacritics'] # already done

	text = verse['text']
	next if text.include?('/') # skip multiple-line verses

	tokens = text.strip.split(/(\W)/,-1) # includes words, spaces, and punctuation
	tokens_down = tokens.map { |t| t = t.downcase }

	# work from last token to previous homonym
	last = tokens.count - 1
	while (!tokens[last].match?(/\w+/)) do # find last token that is a word
		last -= 1
	end

	prevs = []
	i = 0
	while (i < last) do
		prevs << i if tokens_down[i] == tokens_down[last]
		i += 1	
	end
	if prevs.count == 1
		tokens[last] = diacritify(tokens[last], MACRON)
		tokens[prevs.first] = diacritify(tokens[prevs.first], BREVE)
	elsif tokens[0].gsub(/[^aeiouyAEIOUY]/, '').length != 1 # if first token is not a monosyllable
		# work from first token to later homonym
		nexts = []
		i = 1
		while (i < last) do
			nexts << i if tokens_down[i] == tokens_down[0]
			i += 1	
		end
		if nexts.count == 1
			tokens[0] = diacritify(tokens[0], BREVE)
			tokens[nexts.first] = diacritify(tokens[nexts.first], MACRON)
		end
	end
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