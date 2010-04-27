require File.expand_path('../../../spec_helper', __FILE__)

# Maglev, ENV.clear not supported, so Environment never empty

describe "ENV.empty?" do

  it "return true if the Environment is empty" do
    if ENV.keys.size > 0
      ENV.empty?.should == false
    end
    orig = ENV.to_hash
    begin
      ENV.clear
      ENV.empty?.should == true
    ensure
      ENV.replace orig
    end
  end

  it "returns false if not empty" do
    if ENV.keys.size > 0
      ENV.empty?.should == false
    end
  end
end
