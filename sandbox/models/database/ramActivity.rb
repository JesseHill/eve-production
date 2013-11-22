require 'active_record'

class RamActivity < ActiveRecord::Base
	self.table_name = "ramActivities"
	self.primary_key = "activityID"
end