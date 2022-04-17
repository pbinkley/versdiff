#!/usr/bin/env ruby

require 'csv'
require 'json'
require 'yaml'
require 'byebug'

data = CSV.read('_data/versdiff.csv', headers: true)
@sourcemetadata = YAML.load_file('_data/sourcemetadata.yaml')

@terms = {}
@genres = {}
@sources = {}
@walther = [{}, {}]

@authorizedsources = []
@sourcemetadata.each do |source|
  @authorizedsources << source['tag'] if source['tag']
end

def gather(str, id, storage)
  units = str.split(';')
  units.each do |unit|
    unit.strip!
    storage[unit] = [] unless storage[unit]
    storage[unit] << id
  end
end

def walther(str, id, storage)
  wp, wc = str.split(' WC ')
  [wp, wc].each_with_index do |str, index|
    # index: 0 = WP, 1 = WC
    next unless str

    units = str.split(';')
    units.each do |unit|
      w = unit.strip.sub(/ .*/, '').match(/(\d*)(.*)/)
      number = w[1].to_i
      suffix = w[2]
      puts "#{index}: #{number}/#{suffix}"
      unit = [number, suffix]
      storage[index][unit] = [] unless storage[index][unit]
      storage[index][unit] << id
    end
  end
end

def saveData(data, filename)
  keys = data.keys.sort_by(&:downcase)
  output = []
  keys.each do |key|
    entry = { tag: key, verses: data[key] }
    if filename == 'sources'
      puts key
      source = @sourcemetadata.find { |s| s['tag'] == key }
      entry['title'] = source['display'] ? source['display'] : source['tag']
      entry['citation'] = source['citation']
    end
    output << entry
  end
  File.write("_data/#{filename}.json", JSON.dump(output))
end

data.each do |row|
  walther(row['walther'], row['id'], @walther) if row['walther']
  gather(row['term'], row['id'], @terms)
  gather(row['genre'], row['id'], @genres)
  # sources: need to strip off the reference, and filter out Walther's sources
  sources = []
  sourcelist = row['source'].split(';').each do |source|
    source = source.strip.sub(/ .*/, '')
    next unless @authorizedsources.include?(source)
    next if sources.include?(source)

    sources << source
  end
  gather(sources.join(';'), row['id'], @sources)
end

@wp = []
@wc = []
@walther[0].sort_by { |e| [e[0], e[1]] }.each { |e|
  @wp << { tag: "#{e[0][0]}#{e[0][1]}", verses: e[1] }
}
@walther[1].sort_by { |e| [e[0], e[1]] }.each { |e|
  @wc << { tag: "#{e[0][0]}#{e[0][1]}", verses: e[1] }
}
@walther = { wp: @wp, wc: @wc }
File.write("_data/walther.json", JSON.dump(@walther))

# save data files
puts 'Saving terms'
saveData(@terms, 'terms')
puts 'Saving genres'
saveData(@genres, 'genres')
puts 'Saving sources'
saveData(@sources, 'sources')

puts 'done'
