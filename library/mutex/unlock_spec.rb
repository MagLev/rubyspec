require File.expand_path('../../../spec_helper', __FILE__)
require 'thread'

describe "Mutex#unlock" do
  it "raises ThreadError unless Mutex is locked" do
    mutex = Mutex.new
    lambda { mutex.unlock }.should raise_error(ThreadError)
  end

  it "raises ThreadError unless thread owns Mutex" do
    mutex = Mutex.new
    wait = Mutex.new
    wait.lock

    th = nil
   not_compliant_on :maglev do
    th = Thread.new do
      mutex.lock
      wait.lock
    end
    # avoid race on mutex.lock
    Thread.pass while th.status and th.status != "sleep"
    lambda { mutex.unlock }.should raise_error(ThreadError)
   end
 
   deviates_on :maglev do
    th = Thread.new do
      # mutex.lock  # maglev does not auto-release on thread exit
      mutex.synchronize { 
        wait.lock
      }
    end
    # avoid race on mutex.lock
    Thread.pass # while th.status and th.status != "sleep"
    lambda { mutex.unlock }.should raise_error(ThreadError)
   end

    wait.unlock
    th.join
  end

  it "raises ThreadError if previously locking thread is gone" do
    mutex = Mutex.new
    th = Thread.new do
      mutex.lock
    end

    th.join

    lambda { mutex.unlock }.should raise_error(ThreadError)
  end

end
