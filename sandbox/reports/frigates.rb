#!/usr/bin/ruby
require 'optparse'
require 'ostruct'

require_relative 'manufacturing_report'
require_relative '../models/build/build'
require_relative '../models/build/job'

report = ManufacturingReport.new

frigate_group_ids = InvMarketGroup.
  find_by_marketGroupID(1361).
  leaf_groups.
  map { |g| g.marketGroupID }

# puts frigate_group_ids

frigates = InvType.where(marketGroupID: frigate_group_ids)
jobs = frigates.map { |f|
  Job.new(f.typeID, 1)
}
report.run(Build.new("All frigates", jobs), false)
