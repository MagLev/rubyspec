require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

with_feature :fork do
  describe "Kernel#fork" do
   not_compliant_on :maglev do # not private method yet
    it "is a private method" do
      Kernel.should have_private_instance_method(:fork)
    end
   end
  end

  describe "Kernel.fork" do
    it "needs to be reviewed for spec completeness"
  end
end
