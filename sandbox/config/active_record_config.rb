require 'active_record'

class ActiveRecordConfig

	def self.init
		dbconfig = YAML::load(File.open('./config/database.yml'))
		ActiveRecord::Base.establish_connection(dbconfig)
	end
end