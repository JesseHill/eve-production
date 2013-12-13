#!/usr/bin/env ruby

require_relative '../config/active_record_config'
require_relative 'market_group_report'

ActiveRecordConfig.init
MarketGroupReport.new(1361).run