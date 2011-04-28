require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/common', __FILE__)
require File.expand_path('../fixtures/example_class', __FILE__)

deviates_on :maglev do
  require 'date' # maglev 1.8.7
end

describe "Object#to_yaml" do

  it "returns the YAML representation of an Array object" do
not_compliant_on :maglev do
    %w( 30 ruby maz irb 99 ).to_yaml.should == "--- \n- \"30\"\n- ruby\n- maz\n- irb\n- \"99\"\n"
end
deviates_on :maglev do
   (ax = %w( 30 ruby maz irb 99 ).to_yaml).should == "---\n- '30'\n- ruby\n- maz\n- irb\n- '99'\n"
end
  end

  it "returns the YAML representation of a Hash object" do
not_compliant_on :maglev do
    { "a" => "b"}.to_yaml.should match_yaml("--- \na: b\n")
end
deviates_on :maglev do
    (ax = { "a" => "b"}.to_yaml).should match_yaml("---\na: b\n")
end
  end

  it "returns the YAML representation of a Class object" do
    FooBar.new("baz").to_yaml.should match_yaml("--- !ruby/object:FooBar\nname: baz\n")

  end

  it "returns the YAML representation of a Date object" do
not_compliant_on :maglev do
    Date.parse('1997/12/30').to_yaml.should == "--- 1997-12-30\n"
end
deviates_on :maglev do
    (ax = Date.parse('1997/12/30').to_yaml).should == "--- 1997-12-30\n...\n"
end
  end

  it "returns the YAML representation of a FalseClass" do
    false_klass = false
    false_klass.should be_kind_of(FalseClass)
not_compliant_on :maglev do
    false_klass.to_yaml.should == "--- false\n"
end
deviates_on :maglev do
    false_klass.to_yaml.should == "--- false\n...\n"
end
  end

  it "returns the YAML representation of a Float object" do
    float = 1.2
    float.should be_kind_of(Float)
not_compliant_on :maglev do
    float.to_yaml.should == "--- 1.2\n"
end
deviates_on :maglev do
    float.to_yaml.should == "--- 1.2\n...\n"
end
  end

  it "returns the YAML representation of an Integer object" do
    int = 20
    int.should be_kind_of(Integer)
not_compliant_on :maglev do
    int.to_yaml.should == "--- 20\n"
end
deviates_on :maglev do
    int.to_yaml.should == "--- 20\n...\n"
end
  end

  it "returns the YAML representation of a NilClass object" do
    nil_klass = nil
    nil_klass.should be_kind_of(NilClass)
not_compliant_on :maglev do
    nil_klass.to_yaml.should == "--- \n"
end
deviates_on :maglev do
    nil_klass.to_yaml.should == "--- !!null \n...\n"
end
  end

  it "returns the YAML represenation of a RegExp object" do
not_compliant_on :maglev do
    Regexp.new('^a-z+:\\s+\w+').to_yaml.should == "--- !ruby/regexp /^a-z+:\\s+\\w+/\n"
end
deviates_on :maglev do
    Regexp.new('^a-z+:\\s+\w+').to_yaml.should == "--- !ruby/regexp /^a-z+:\\s+\\w+/\n...\n"
end
  end

  it "returns the YAML representation of a String object" do
not_compliant_on :maglev do
    "I love Ruby".to_yaml.should == "--- I love Ruby\n"
end
deviates_on :maglev do
    "I love Ruby".to_yaml.should == "--- I love Ruby\n...\n"
end
  end

  it "returns the YAML representation of a Struct object" do
    Person = Struct.new(:name, :gender)
    Person.new("Jane", "female").to_yaml.should match_yaml("--- !ruby/struct:Person\nname: Jane\ngender: female\n")
  end

  it "returns the YAML representation of a Symbol object" do
not_compliant_on :maglev do
    :symbol.to_yaml.should ==  "--- :symbol\n"
end
deviates_on :maglev do
    :symbol.to_yaml.should ==  "--- :symbol\n...\n"
end
  end

  it "returns the YAML representation of a Time object" do
not_compliant_on :maglev do
    Time.utc(2000,"jan",1,20,15,1).to_yaml.should ==        "--- 2000-01-01 20:15:01 Z\n"
end
deviates_on :maglev do
    (ax = Time.utc(2000,"jan",1,20,15,1).to_yaml).should == "--- 2000-01-01 20:15:01.000000Z\n...\n"
end
  end

  it "returns the YAML representation of a TrueClass" do
    true_klass = true
    true_klass.should be_kind_of(TrueClass)
not_compliant_on :maglev do
    true_klass.to_yaml.should == "--- true\n"
end
deviates_on :maglev do
    true_klass.to_yaml.should == "--- true\n...\n"
end
  end  

  it "returns the YAML representation of a Error object" do
not_compliant_on :maglev do
   StandardError.new("foobar").to_yaml.should match_yaml("--- !ruby/exception:StandardError\nmessage: foobar\n")
end
deviates_on :maglev do
   bx = "--- !ruby/exception:StandardError\nmessage: foobar\n_st_messageText: foobar\n_st_gsArgs: !!null \n"  # maglev deviation
   (ax = StandardError.new("foobar").to_yaml).should == bx
end
  end

  it "returns the YAML representation for Range objects" do
    yaml = Range.new(1,3).to_yaml
    yaml.include?("!ruby/range").should be_true
    yaml.include?("begin: 1").should be_true
    yaml.include?("end: 3").should be_true
    yaml.include?("excl: false").should be_true
  end

  it "returns the YAML representation of numeric constants" do
not_compliant_on :maglev do
    (0.0/0.0).to_yaml.should == "--- .NaN\n"
    (1.0/0.0).to_yaml.should == "--- .Inf\n"
    (-1.0/0.0).to_yaml.should == "--- -.Inf\n"
    (0.0).to_yaml.should == "--- 0.0\n"
end
deviates_on :maglev do
    (0.0/0.0).to_yaml.should == "--- .nan\n...\n"
    (1.0/0.0).to_yaml.should == "--- .inf\n...\n"
    (-1.0/0.0).to_yaml.should == "--- -.inf\n...\n"
    (0.0).to_yaml.should == "--- 0.0\n...\n"
end
  end

  it "returns the YAML representation of an array of hashes" do
    players = [{"a" => "b"}, {"b" => "c"}]
not_compliant_on :maglev do
    players.to_yaml.should == "--- \n- a: b\n- b: c\n"
end
deviates_on :maglev do
    players.to_yaml.should == "---\n- a: b\n- b: c\n"
end
  end
end
