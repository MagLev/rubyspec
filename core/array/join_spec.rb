require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)
require  File.dirname(__FILE__) + '/../../shared/array/join'

describe "Array#join" do

  it_behaves_like :array_join, :join, ArraySpecs::NewArray

  it "does not separates elements when the passed separator is nil" do
    [1, 2, 3].join(nil).should == '123'
  end

  it "uses $, as the default separator (which defaults to nil)" do
    [1, 2, 3].join.should == '123'
    begin
      old, $, = $,, '-'
      [1, 2, 3].join.should == '1-2-3'
    ensure
      $, = old
    end
  end

  it "does not process the separator if the array is empty" do
    a = []
    sep = Object.new
    a.join(sep).should == ""
  end

  it "calls #to_str to convert the separator to a String" do
    sep = mock("separator")
    sep.should_receive(:to_str).and_return(", ")
    [1, 2].send(@method, sep).should == "1, 2"
  end

  it "raises a TypeError if the separator cannot be coerced to a String by calling #to_str" do
    obj = mock("not a string")
    lambda { [1, 2].send(@method, obj) }.should raise_error(NoMethodError) # Maglev, was TypeError
  end
end
