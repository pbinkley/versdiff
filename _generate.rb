#!/usr/bin/env ruby

require 'csv'
require 'json'
require 'byebug'

data = CSV.read('_data/versdiff.csv', headers: true)

@terms = {}
@genres = {}
@sources = {}

AUTHORIZEDSOURCES = ['Acc', 'Aimericus', 'Doctrinale', 'Gra', 'Graec', 'Rad', 'Serlo', 'Siguinus', 'Tra']

def gather(str, id, storage)
  units = str.split(';')
  units.each do |unit|
    unit.strip!
    storage[unit] = [] unless storage[unit]
    storage[unit] << id
  end
end

def saveData(data, filename)
  keys = data.keys.sort_by(&:downcase)
  output = [] 
  keys.each { |key| output << { tag: key, verses: data[key] } }
  File.write("_data/#{filename}.json", JSON.dump(output))
end

data.each do |row|
  gather(row['term'], row['id'], @terms)
  gather(row['genre'], row['id'], @genres)
  # sources: need to strip off the reference, and filter out Walther's sources
  sources = []
  sourcelist = row['source'].split(';').each do |source|
    source = source.strip.sub(/ .*/, '')
    next unless AUTHORIZEDSOURCES.include?(source)
    next if sources.include?(source)

    sources << source
  end
  gather(sources.join(';'), row['id'], @sources)
end

# save data files
puts 'Saving terms'
saveData(@terms, 'terms')
puts 'Saving genres'
saveData(@genres, 'genres')
puts 'Saving sources'
saveData(@sources, 'sources')

puts 'done'
