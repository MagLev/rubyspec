require File.expand_path('../../../spec_helper', __FILE__)

describe "Bignum#hash" do
  it "is provided" do
    bignum_value.respond_to?(:hash).should == true
  end

  it "is stable" do
    aa = bignum_value
    aa.hash.should == aa.hash
    bb = bignum_value(1000000)  # Maglev varitions on hash function
    aa.hash.should_not == bb.hash
  end
end
