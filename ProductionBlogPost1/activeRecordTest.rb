require 'rubygems'
require 'active_record'
require 'yaml'
require './models/database/invType.rb'
 
dbconfig = YAML::load(File.open('database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)

type = InvType.find_by(typeID: '11269')
puts type.typeName
puts type.description
puts "\nWaste factor: #{type.inv_blueprint_type.wasteFactor}\n"

puts "\nBase materials"
type.inv_type_materials.each {|material|
	puts material.required_type.typeName + " " + material.quantity.to_s
}
puts "\nRam requirements"
type.ram_type_requirements.each {|r|
	puts "#{r.required_type.typeName} #{r.quantity} #{r.required_type.group.categoryID}"
}