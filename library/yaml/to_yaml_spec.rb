require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/common', __FILE__)
require File.expand_path('../fixtures/example_class', __FILE__)

if defined?(Maglev)
  require 'date' # maglev 1.8.7
end

describe "Object#to_yaml" do

  it "returns the YAML representation of an Array object" do
    # %w( 30 ruby maz irb 99 ).to_yaml).should ==    "--- \n- \"30\"\n- ruby\n- maz\n- irb\n- \"99\"\n"
   (ax = %w( 30 ruby maz irb 99 ).to_yaml).should == "---\n- '30'\n- ruby\n- maz\n- irb\n- '99'\n"
  end

  it "returns the YAML representation of a Hash object" do
    # { "a" => "b"}.to_yaml.should match_yaml("--- \na: b\n")
    (ax = { "a" => "b"}.to_yaml).should match_yaml("---\na: b\n")
  end

  it "returns the YAML representation of a Class object" do
    FooBar.new("baz").to_yaml.should match_yaml("--- !ruby/object:FooBar\nname: baz\n")

  end

  it "returns the YAML representation of a Date object" do
    #Date.parse('1997/12/30').to_yaml.should == "--- 1997-12-30\n"
    (ax = Date.parse('1997/12/30').to_yaml).should == "--- 1997-12-30\n...\n"
  end

  it "returns the YAML representation of a FalseClass" do
    false_klass = false
    false_klass.should be_kind_of(FalseClass)
   #false_klass.to_yaml.should == "--- false\n"
    false_klass.to_yaml.should == "--- false\n...\n"
  end

  it "returns the YAML representation of a Float object" do
    float = 1.2
    float.should be_kind_of(Float)
   #float.to_yaml.should == "--- 1.2\n"
    float.to_yaml.should == "--- 1.2\n...\n"
  end
  
  it "returns the YAML representation of an Integer object" do
    int = 20
    int.should be_kind_of(Integer)
   #int.to_yaml.should == "--- 20\n"
    int.to_yaml.should == "--- 20\n...\n"
  end
  
  it "returns the YAML representation of a NilClass object" do
    nil_klass = nil
    nil_klass.should be_kind_of(NilClass)
   #nil_klass.to_yaml.should == "--- \n"
    nil_klass.to_yaml.should == "--- !!null \n...\n"
  end
  
  it "returns the YAML represenation of a RegExp object" do
   #Regexp.new('^a-z+:\\s+\w+').to_yaml.should == "--- !ruby/regexp /^a-z+:\\s+\\w+/\n"
    Regexp.new('^a-z+:\\s+\w+').to_yaml.should == "--- !ruby/regexp /^a-z+:\\s+\\w+/\n...\n"
  end
  
  it "returns the YAML representation of a String object" do
   #"I love Ruby".to_yaml.should == "--- I love Ruby\n"
    "I love Ruby".to_yaml.should == "--- I love Ruby\n...\n"
  end

  it "returns the YAML representation of a Struct object" do
    Person = Struct.new(:name, :gender)
    Person.new("Jane", "female").to_yaml.should match_yaml("--- !ruby/struct:Person\nname: Jane\ngender: female\n")
  end

  it "returns the YAML representation of a Symbol object" do
  # :symbol.to_yaml.should ==  "--- :symbol\n"
    :symbol.to_yaml.should ==  "--- :symbol\n...\n"
  end
  
  it "returns the YAML representation of a Time object" do
   #Time.utc(2000,"jan",1,20,15,1).to_yaml.should ==        "--- 2000-01-01 20:15:01 Z\n"
    (ax = Time.utc(2000,"jan",1,20,15,1).to_yaml).should == "--- 2000-01-01 20:15:01.000000Z\n...\n"
  end
  
  it "returns the YAML representation of a TrueClass" do
    true_klass = true
    true_klass.should be_kind_of(TrueClass)
   #true_klass.to_yaml.should == "--- true\n"
    true_klass.to_yaml.should == "--- true\n...\n"
  end  

  it "returns the YAML representation of a Error object" do
   #StandardError.new("foobar").to_yaml).should match_yaml("--- !ruby/exception:StandardError\nmessage: foobar\n")
   bx = "--- !ruby/exception:StandardError\nmessage: foobar\n_st_messageText: foobar\n_st_gsArgs: !!null \n"  # maglev deviation
   (ax = StandardError.new("foobar").to_yaml).should == bx
  end

  it "returns the YAML representation for Range objects" do
    yaml = Range.new(1,3).to_yaml
    yaml.include?("!ruby/range").should be_true
    yaml.include?("begin: 1").should be_true
    yaml.include?("end: 3").should be_true
    yaml.include?("excl: false").should be_true
  end

  it "returns the YAML representation of numeric constants" do
   #(0.0/0.0).to_yaml.should == "--- .NaN\n"
   #(1.0/0.0).to_yaml.should == "--- .Inf\n"
   #(-1.0/0.0).to_yaml.should == "--- -.Inf\n"
   #(0.0).to_yaml.should == "--- 0.0\n"
    (0.0/0.0).to_yaml.should == "--- .nan\n...\n"
    (1.0/0.0).to_yaml.should == "--- .inf\n...\n"
    (-1.0/0.0).to_yaml.should == "--- -.inf\n...\n"
    (0.0).to_yaml.should == "--- 0.0\n...\n"
  end

  it "returns the YAML representation of an array of hashes" do
    players = [{"a" => "b"}, {"b" => "c"}]
   #players.to_yaml.should == "--- \n- a: b\n- b: c\n"
    players.to_yaml.should == "---\n- a: b\n- b: c\n"
  end
end
