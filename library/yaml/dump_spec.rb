require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/common', __FILE__)

# TODO: WTF is this using a global?
describe "YAML.dump" do
  after :each do
    rm_r $test_file
  end

  it "converts an object to YAML and write result to io when io provided" do
    File.open($test_file, 'w' ) do |io|
      YAML.dump( ['badger', 'elephant', 'tiger'], io )
    end
    YAML.load_file($test_file).should == ['badger', 'elephant', 'tiger']
  end

  it "returns a string containing dumped YAML when no io provided" do
   not_compliant_on :maglev do
    YAML.dump( :locked ).should == "--- :locked\n"
   end
   deviates_on :maglev do
    YAML.dump( :locked ).should == "--- :locked\n...\n"
   end
  end  

  it "returns the same string that #to_yaml on objects" do
    ["a", "b", "c"].to_yaml.should == YAML.dump(["a", "b", "c"])
  end

  it "dumps strings into YAML strings" do
   not_compliant_on :maglev do
    YAML.dump("str").should == "--- str\n"
   end
   deviates_on :maglev do
    YAML.dump("str").should == "--- str\n...\n"
   end
  end

  it "dumps hashes into YAML key-values" do
   not_compliant_on :maglev do
    YAML.dump({ "a" => "b" }).should ==  "--- \na: b\n"
   end
   deviates_on :maglev do
    YAML.dump({ "a" => "b" }).should ==   "---\na: b\n"
   end
  end

  it "dumps Arrays into YAML collection" do
   not_compliant_on :maglev do
    YAML.dump(["a", "b", "c"]).should == "--- \n- a\n- b\n- c\n"
   end
   deviates_on :maglev do
    YAML.dump(["a", "b", "c"]).should ==  "---\n- a\n- b\n- c\n"
   end
  end
end
