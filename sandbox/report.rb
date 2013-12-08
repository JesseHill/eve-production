#!/usr/bin/ruby

require_relative './reports/manufacturing_report'
require_relative './models/build/build'
require_relative './models/build/job'

report = ManufacturingReport.new

# Set up our list of jobs
jobs = [
	["Warp Scrambler II", 100],
	["Expanded Cargohold II", 100],
	["Arazu", 2],
	["250mm Railgun II", 20],
].map { |name, count| Job.new(name, count) }

build = Build.new("Overall Build", 1, jobs)

report.run(build)
