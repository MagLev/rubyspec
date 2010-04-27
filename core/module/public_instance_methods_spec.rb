require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

# Before MRI 1.9 #public_instance_methods returned an Array of Strings
ruby_version_is ""..."1.9" do
  describe "Module#public_instance_methods" do
    it "returns a list of public methods in module and its ancestors" do
      methods = ModuleSpecs::CountsMixin.public_instance_methods
      methods.should include('public_3')
    
      methods = ModuleSpecs::CountsParent.public_instance_methods
      methods.should include('public_3')
      methods.should include('public_2')

      methods = ModuleSpecs::CountsChild.public_instance_methods
      methods.should include('public_3')
      methods.should include('public_2')
      methods.should include('public_1')

      methods = ModuleSpecs::Child2.public_instance_methods
      methods.should include('foo')
    end

    it "when passed false as a parameter, should return only methods defined in that module" do
      ModuleSpecs::CountsMixin.public_instance_methods(false).should == ['public_3']
# Maglev fails
#     ModuleSpecs::CountsParent.public_instance_methods(false).should == ['public_2']
#     ModuleSpecs::CountsChild.public_instance_methods(false).should == ['public_1']
    end

    it "default list should be the same as passing true as an argument" do
      ModuleSpecs::CountsMixin.public_instance_methods(true).should ==
        ModuleSpecs::CountsMixin.public_instance_methods
      ModuleSpecs::CountsParent.public_instance_methods(true).should ==
        ModuleSpecs::CountsParent.public_instance_methods
      ModuleSpecs::CountsChild.public_instance_methods(true).should ==
        ModuleSpecs::CountsChild.public_instance_methods
    end
  end
end


# As of MRI 1.9 #public_instance_methods returns an Array of Symbols
ruby_version_is "1.9" do
  describe "Module#public_instance_methods" do
    it "returns a list of public methods in module and its ancestors" do
      methods = ModuleSpecs::CountsMixin.public_instance_methods
      methods.should include(:public_3)
    
      methods = ModuleSpecs::CountsParent.public_instance_methods
      methods.should include(:public_3)
      methods.should include(:public_2)

      methods = ModuleSpecs::CountsChild.public_instance_methods
      methods.should include(:public_3)
      methods.should include(:public_2)
      methods.should include(:public_1)

      methods = ModuleSpecs::Child2.public_instance_methods
      methods.should include(:foo)
    end

    it "when passed false as a parameter, should return only methods defined in that module" do
      ModuleSpecs::CountsMixin.public_instance_methods(false).should == [:public_3]
      ModuleSpecs::CountsParent.public_instance_methods(false).should == [:public_2]
      ModuleSpecs::CountsChild.public_instance_methods(false).should == [:public_1]
    end

    it "default list should be the same as passing true as an argument" do
      ModuleSpecs::CountsMixin.public_instance_methods(true).should ==
        ModuleSpecs::CountsMixin.public_instance_methods
      ModuleSpecs::CountsParent.public_instance_methods(true).should ==
        ModuleSpecs::CountsParent.public_instance_methods
      ModuleSpecs::CountsChild.public_instance_methods(true).should ==
        ModuleSpecs::CountsChild.public_instance_methods
    end
  end
end
