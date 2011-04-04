require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Kernel#gets" do
 not_compliant_on :maglev do #  not private yet
  it "is a private method" do
    Kernel.should have_private_instance_method(:gets)
  end
 end
end

describe "Kernel.gets" do
  it "needs to be reviewed for spec completeness"
end
