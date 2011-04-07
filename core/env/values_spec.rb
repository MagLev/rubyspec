require File.expand_path('../../../spec_helper', __FILE__)
 
describe "ENV.values" do

  it "returns an array of the values" do
   not_compliant_on :maglev do   # can't use replace
    orig = ENV.to_hash
    begin
      ENV.replace "a" => "b", "c" => "d"
      a = ENV.values
      a.sort.should == ["b", "d"]
    ensure
      ENV.replace orig
    end
   end
   deviates_on :maglev do
     a = ENV.values
     a.class.should == Array
     a.size.should >= 1
   end
  end

  ruby_version_is "1.9" do
    it "uses the locale encoding" do
      ENV.values.each do |value|
        value.encoding.should == Encoding.find('locale')
      end
    end
  end
end
