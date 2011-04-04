require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Kernel#set_trace_func" do
 not_compliant_on :maglev do #  not private yet
  it "is a private method" do
    Kernel.should have_private_instance_method(:set_trace_func)
  end
 end
end

describe "Kernel.set_trace_func" do
  it "needs to be reviewed for spec completeness"
end
