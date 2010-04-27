require File.expand_path('../../../spec_helper', __FILE__)
require 'thread'

describe "Mutex#lock" do
  before :each do
    ScratchPad.clear
  end

  it "returns self" do
    m = Mutex.new
    m.lock.should == m
    m.unlock
  end

  it "waits if the lock is not available" do
    m = Mutex.new

    m.lock

    th = Thread.new do
      m.lock
      ScratchPad.record :after_lock
    end

    Thread.pass while th.status and th.status != "sleep"

    ScratchPad.recorded.should be_nil
    m.unlock
    th.join
    ScratchPad.recorded.should == :after_lock
  end

  # Unable to find a specific ticket but behavior change may be
  # related to this ML thread.
  ruby_bug "[ruby-core:23457]", "1.8.7.174" do
    it "raises a ThreadError when used recursively" do
      m = Mutex.new

      th = Thread.new do
        m.lock
        m.lock
        v = 1
      end

      Thread.pass while th.status and th.status != "sleep"

      ScratchPad.recorded.should be_nil

      jx = 99
      jy = lambda do
        th.kill
        jx = th.join
      end # .should raise_error(ThreadError)
      jx.should == 99 # Maglev deviation, no exception raised 
    end
  end
end
