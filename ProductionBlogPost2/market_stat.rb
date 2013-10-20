#!/usr/bin/ruby
require 'nokogiri'
require 'open-uri'

abort("Please pass an item id to be looked up.") unless ARGV.length > 0
typeID = ARGV[0]
api = "http://api.eve-central.com/api/marketstat?typeid=#{typeID}"
puts "Getting market data: #{typeID} ..."
marketData = Nokogiri::XML(open(api))
price = marketData.css("all avg")[0].content
puts "The average market price for type #{typeID} is #{price}"

