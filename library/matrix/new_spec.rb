require File.expand_path('../../../spec_helper', __FILE__)
require 'matrix'

describe "Matrix#new" do
  
  it "is not accessible" do
    #lambda { Matrix.new }.should raise_error(NoMethodError)
    lambda { Matrix.new }.should raise_error(ArgumentError) # maglev deviation
  end
  
end
