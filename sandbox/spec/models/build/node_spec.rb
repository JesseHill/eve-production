require_relative '../../spec_helper'
require_relative '../../../models/build/node'

class TestVisitor

	def visit(n)
		n.data[:value] = "modified"
		n.runs *= 2
	end

end

describe Node do

	it 'should load return a copy when visited' do
		children = [Node.new("One", 1), Node.new("Two", 2)]
	 	root = Node.new("Root", 1, children)
	 	root.data[:value] = "original"
	 	root.children[0].data[:value] = "original"
	 	root.children[1].data[:value] = "original"

	 	visited = root.accept(TestVisitor.new)
	 	visited.name = "Visited"

	 	root.name.should eq("Root")
	 	root.runs.should eq(1)
	 	root.data[:value].should eq("original")
	 	root.children[0].data[:value].should eq("original")	
	 	root.children[1].data[:value].should eq("original")	

	 	visited.name.should eq("Visited")
	 	visited.runs.should eq(2)
	 	visited.data[:value].should eq("modified")
	 	visited.children[0].data[:value].should eq("modified")	
	 	visited.children[1].data[:value].should eq("modified")	
	end

	it 'should sort correctly' do
		children = [Node.new("One", 10), Node.new("Two", 5)]
	 	root = Node.new("Root", 1, children)

	 	sorted = root.sort_by { |n| n.runs }

	 	root.children[0].name.should eq("One")	
	 	root.children[1].name.should eq("Two")	
	 	
	 	sorted.children[0].name.should eq("Two")	
	 	sorted.children[1].name.should eq("One")	
	end	

	it 'should iterate correctly' do
		children = [Node.new("One", 10), Node.new("Two", 5)]
	 	root = Node.new("Root", 1, children)
	 	count = 0
	 	root.each { |n| count += n.runs }
	 	count.should eq(16)	
	end		

end