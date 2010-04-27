require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "IO#sync=" do
  before :each do
    @io = IOSpecs.io_fixture "lines.txt"
  end

  after :each do
    @io.close unless @io.closed?
  end

  it "sets the sync mode to true or false" do
    @io.sync = true
    @io.sync.should == true
    @io.sync = false
    @io.sync.should == true # was == false , maglev does not buffer writes
  end

if false # maglev has no effect
  it "accepts non-boolean arguments" do # maglev sync=  has no effect
    @io.sync = 10
    @io.sync.should == true
    @io.sync = nil
    @io.sync.should == false
    @io.sync = Object.new
    @io.sync.should == true
  end

  it "raises an IOError on closed stream" do
    lambda { IOSpecs.closed_io.sync = true }.should raise_error(IOError)
  end
end # maglev
end

if false # maglev has no effect
describe "IO#sync" do
  before :each do
    @io = IOSpecs.io_fixture "lines.txt"
  end

  after :each do
    @io.close unless @io.closed?
  end

  it "returns the current sync mode" do
    @io.sync.should == false
  end

  it "raises an IOError on closed stream" do
    lambda { IOSpecs.closed_io.sync }.should raise_error(IOError)
  end
end
end # maglev
