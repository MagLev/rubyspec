require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/common', __FILE__)

describe "YAML.dump_stream" do
  it "returns an empty string when not passed any objects" do
   not_compliant_on :maglev do
    YAML.dump_stream.should == ""
   end
   deviates_on :maglev do
    YAML.dump_stream.should == "--- !!null \n...\n"  # maglev deviation
   end
  end

  it "returns a YAML stream containing the objects passed" do
   not_compliant_on :maglev do
    YAML.dump_stream('foo', 20, [], {}).should ==             "--- foo\n--- 20\n--- []\n\n--- {}\n\n"
   end
   deviates_on :maglev do
    (ax = YAML.dump_stream('foo', 20, [], {})).should == (bx = "--- foo\n--- 20\n--- []\n--- {}\n" )
   end
  end
end
