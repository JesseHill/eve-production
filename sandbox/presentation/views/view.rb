require 'mustache'
require 'active_support/inflector'
require_relative "../formatting"

class View < Mustache
	include ActiveSupport::Inflector
	include Formatting

	attr_accessor :template_folder

	def initialize(options = {})
		@options = options
		@parent_folder = File.expand_path("..", File.dirname(__FILE__))
		self.template_file = resolve_template
	end

	def template_file_name
		self.class.name.chomp("View").underscore
	end

	def resolve_template
		format = @options[:output_format] || 'text'
		report_type = @options[:report_type]
		Pathname.new("#{format}/#{template_folder}/#{report_type}").ascend do |path| 
			file_name = "#{File.dirname(__FILE__)}/templates/#{path}/#{template_file_name}.mustache"
			# puts "Checking filename: #{file_name}"
			return file_name if File.exists?(file_name)
		end
		nil
	end

end