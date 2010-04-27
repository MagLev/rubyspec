require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Kernel#initialize_copy" do
  it "is a private method" do
    # Kernel.should have_private_instance_method(:initialize_copy)
    Kernel.should_not have_private_instance_method(:initialize_copy)
    Object.should have_private_instance_method(:initialize_copy) # Maglev deviation
  end
end
