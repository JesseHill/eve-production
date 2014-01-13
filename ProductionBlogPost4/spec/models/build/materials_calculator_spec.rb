require_relative '../../spec_helper'
require_relative '../../../models/database/inv_type'
require_relative '../../../models/build/materials_calculator'

describe MaterialsCalculator do

	before :each do
		@blueprint_repo = mock('repo')
		@waste_calculator = WasteCalculator.new(5, @blueprint_repo)
		@materials_calculator = MaterialsCalculator.new(@waste_calculator)
	end

	it 'should calculate materials for a tech I item correctly' do
		blueprint = InvType.find_by_typeName('Worm').inv_blueprint_type
		@blueprint_repo.expects(:material_level).returns(0).at_least_once
		materials = @materials_calculator.required_materials(blueprint, 10)

		materials.length.should eq(7)
		materials[InvType.find_by_typeName('Tritanium')].should eq(208600)
		materials[InvType.find_by_typeName('Pyerite')].should eq(92880)
		materials[InvType.find_by_typeName('Mexallon')].should eq(30950)
		materials[InvType.find_by_typeName('Isogen')].should eq(5840)
		materials[InvType.find_by_typeName('Nocxium')].should eq(20)
		materials[InvType.find_by_typeName('Zydrine')].should eq(20)
		materials[InvType.find_by_typeName('Megacyte')].should eq(20)
	end	

	it 'should calculate materials for a tech II item correctly' do
		blueprint = InvType.find_by_typeName('Crow').inv_blueprint_type
		@blueprint_repo.expects(:material_level).returns(-4).at_least_once
		materials = @materials_calculator.required_materials(blueprint, 1)

		materials.length.should eq(17)
		materials[InvType.find_by_typeName('Tritanium')].should eq(300)
		materials[InvType.find_by_typeName('Pyerite')].should eq(300)
		materials[InvType.find_by_typeName('Mexallon')].should eq(30)
		materials[InvType.find_by_typeName('Isogen')].should eq(30)
		materials[InvType.find_by_typeName('Zydrine')].should eq(15)
		materials[InvType.find_by_typeName('Megacyte')].should eq(15)
		materials[InvType.find_by_typeName('Morphite')].should eq(8)
		materials[InvType.find_by_typeName('Construction Blocks')].should eq(15)
		materials[InvType.find_by_typeName('Magpulse Thruster')].should eq(45)
		materials[InvType.find_by_typeName('Gravimetric Sensor Cluster')].should eq(30)
		materials[InvType.find_by_typeName('Quantum Microprocessor')].should eq(120)
		materials[InvType.find_by_typeName('Titanium Diborite Armor Plate')].should eq(450)
		materials[InvType.find_by_typeName('Graviton Reactor Unit')].should eq(5)
		materials[InvType.find_by_typeName('Scalar Capacitor Unit')].should eq(75)
		materials[InvType.find_by_typeName('Sustained Shield Emitter')].should eq(23)
		materials[InvType.find_by_typeName('Condor')].should eq(1)
		materials[InvType.find_by_typeName('R.A.M.- Starship Tech')].should eq(1)
	end		

end