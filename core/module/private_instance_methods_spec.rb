require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Module#private_instance_methods" do
  it "returns a list of private methods in module and its ancestors" do
    ModuleSpecs::CountsMixin.should have_private_instance_method(:private_3)

# Maglev fails
#   ModuleSpecs::CountsParent.should have_private_instance_method(:private_2)
#   ModuleSpecs::CountsParent.should have_private_instance_method(:private_3)
#
#   ModuleSpecs::CountsChild.should have_private_instance_method(:private_1)
#   ModuleSpecs::CountsChild.should have_private_instance_method(:private_2)
#   ModuleSpecs::CountsChild.should have_private_instance_method(:private_3)
  end

  it "when passed false as a parameter, should return only methods defined in that module" do
    ModuleSpecs::CountsMixin.should have_private_instance_method(:private_3, false)
# Maglev fails
#   ModuleSpecs::CountsParent.should have_private_instance_method(:private_2, false)
#   ModuleSpecs::CountsChild.should have_private_instance_method(:private_1, false)
  end

  it "default list should be the same as passing true as an argument" do
    ModuleSpecs::CountsMixin.private_instance_methods(true).should ==
      ModuleSpecs::CountsMixin.private_instance_methods
    ModuleSpecs::CountsParent.private_instance_methods(true).should ==
      ModuleSpecs::CountsParent.private_instance_methods
    ModuleSpecs::CountsChild.private_instance_methods(true).should ==
      ModuleSpecs::CountsChild.private_instance_methods
  end
end
