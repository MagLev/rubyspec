require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/shared/match'

describe "Regexp#=~" do
  it_behaves_like(:regexp_match, :=~)
end

describe "Regexp#match" do
  it_behaves_like(:regexp_match, :match)

  ruby_version_is ""..."1.9" do
    it "coerces Exceptions into strings" do
      f = Exception.new("foo")
      /foo/.match(f)[0].should == "foo"
    end
  end

  ruby_version_is "1.9" do
    it "raises TypeError when the given argument is an Exception" do
      f = Exception.new("foo")
      lambda { /foo/.match(f)[0] }.should raise_error(TypeError)
    end
  end
end

describe "Regexp#~" do
  it "matches against the contents of $_" do
    $_ = "input data"
    (~ /at/).should == 7
  end
end

describe "Regexp#=~ on a successful match" do
  it "returns the index of the first character of the matching region" do
    (/(.)(.)(.)/ =~ "abc").should == 0
  end
end

describe "Regexp#match on a successful match" do
  it "returns a MatchData object" do
    /(.)(.)(.)/.match("abc").should be_kind_of(MatchData)
  end

  it "resets $~ if passed nil" do
    # set $~
    /./.match("a")
    $~.should be_kind_of(MatchData)

    /1/.match(nil)
    $~.should be_nil
  end
end
