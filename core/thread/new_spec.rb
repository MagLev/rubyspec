require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Thread.new" do
  it "creates a thread executing the given block" do
    c = Channel.new
    Thread.new { c << true }.join
    c << false
    c.receive.should == true
  end
  
  it "can pass arguments to the thread block" do
    arr = []
    a, b, c = 1, 2, 3
    t = Thread.new(a,b,c) {|d,e,f| arr << d << e << f }
    t.join
    arr.should == [a,b,c]
  end

  it "raises an exception when not given a block" do
    tx = Thread
    lambda { Thread.new }.should raise_error(ThreadError)
  end

 not_compliant_on :maglev do
  it "creates a subclass of thread calls super with a block in initialize" do #
    arr = []
    t = ThreadSpecs::SubThread.new(arr)
    t.join
    arr.should == [1]
  end
 end

end
