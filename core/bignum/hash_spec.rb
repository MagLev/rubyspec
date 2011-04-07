require File.expand_path('../../../spec_helper', __FILE__)

describe "Bignum#hash" do
  it "is provided" do
    bignum_value.respond_to?(:hash).should == true
  end

  it "is stable" do
    bignum_value.hash.should == bignum_value.hash
    not_compliant_on :maglev do
      bignum_value.hash.should_not == bignum_value(1).hash
    end
    deviates_on :maglev do  # different implementation of hash function
      bignum_value.hash.should_not == bignum_value(1000000).hash
    end
  end
end
