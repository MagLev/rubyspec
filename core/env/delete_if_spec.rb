require File.expand_path('../../../spec_helper', __FILE__)

# Maglev, ENV.delete not supported, do not run this file

describe "ENV.delete_if" do

  it "deletes pairs if the block returns true" do
    ENV["foo"] = "bar"
    ENV.delete_if { |k, v| k == "foo" }
    ENV["foo"].should == nil
  end

  it "returns ENV even if nothing deleted" do
    ENV.delete_if { false }.should_not == nil
  end

#  ruby_version_is "" ... "1.8.7" do 
   ruby_version_is "" .. "1.8.7" do   # maglev 1.8.7 still requires a block 
    it "raises LocalJumpError if no block given" do #
      lambda { ENV.delete_if }.should raise_error(LocalJumpError)
    end
  end

 not_compliant_on :maglev do  # enumerator not supported on ENV.delete_if
  ruby_version_is "1.8.7" do
    it "returns an Enumerator if no block given" do
      ENV.delete_if.should be_an_instance_of(enumerator_class)
    end
  end
 end #

end
