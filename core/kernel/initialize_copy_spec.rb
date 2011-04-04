require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Kernel#initialize_copy" do
  it "is a private method" do
   not_compliant_on :maglev do
    Kernel.should have_private_instance_method(:initialize_copy)
   end
   deviates_on :maglev do
    Kernel.should_not have_private_instance_method(:initialize_copy)
    Object.should have_private_instance_method(:initialize_copy)
   end
  end
end
