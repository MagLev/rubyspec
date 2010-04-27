require File.expand_path('../../../spec_helper', __FILE__)
require 'thread'

describe "Mutex#locked?" do
  it "returns true if locked" do
    m = Mutex.new
    m.lock
    m.locked?.should be_true
  end

  it "returns false if unlocked" do
    m = Mutex.new
    m.locked?.should be_false
  end

  it "returns the status of the lock" do
    m1 = Mutex.new
    m2 = Mutex.new

    m2.lock # hold th with only m1 locked

    other_done = false

    th = Thread.new do
      # m1.lock  # Maglev deviation, thread exit does not release mutexes
      # m2.lock
      m1.synchronize { 
        m2.synchronize {  }
      }
    end

    Thread.pass # while th.status and th.status != "sleep"

    m1.locked?.should be_true
    m2.unlock # release th
    th.join
    m1.locked?.should be_false
  end
end
