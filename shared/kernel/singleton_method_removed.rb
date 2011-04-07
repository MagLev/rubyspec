require File.expand_path('../../../spec_helper', __FILE__)

describe :singleton_method_removed, :shared => true do
 not_compliant_on :maglev do  # method exists, but not private yet
  it "is a private method" do
    @object.should have_private_instance_method(@method)
  end
 end
end
