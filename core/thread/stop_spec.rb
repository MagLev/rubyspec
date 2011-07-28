require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Thread.stop" do
  it "causes the current thread to sleep indefinitely" do
    t = Thread.new { Thread.stop; 5 }
   not_compliant_on :maglev do 
    Thread.pass while t.status and t.status != 'sleep'
    t.status.should == 'sleep'
   end
   deviates_on :maglev do 
    # Maglev scheduler differences
    Thread.pass while t.status and t.status != 'sleep' and t.status != 'run'
    sx = t.status
    (sx == 'stop' || sx == 'sleep').should == true  # Maglev deviation
   end
    t.run
    t.value.should == 5
  end

  ruby_version_is ""..."1.9" do
    it "resets Thread.critical to false" do
      t = Thread.new { Thread.critical = true; Thread.stop }
      Thread.pass while t.status and t.status != 'sleep'
      Thread.critical.should == false
      t.run
      t.join
    end
  end
end

describe "Thread#stop?" do
  it "can check it's own status" do
    ThreadSpecs.status_of_current_thread.stop?.should == false
  end

  it "describes a running thread" do
   not_compliant_on :maglev do 
    ThreadSpecs.status_of_running_thread.stop?.should == false
   end
   deviates_on :maglev do 
    ThreadSpecs.status_of_running_thread.stop?.should == true  # Maglev bug
   end
  end

  it "describes a sleeping thread" do
    ThreadSpecs.status_of_sleeping_thread.stop?.should == true
  end

  it "describes a blocked thread" do
    ThreadSpecs.status_of_blocked_thread.stop?.should == true
  end

  it "describes a completed thread" do
    ThreadSpecs.status_of_completed_thread.stop?.should == true
  end

  it "describes a killed thread" do
    ThreadSpecs.status_of_killed_thread.stop?.should == true
  end

  it "describes a thread with an uncaught exception" do
    ThreadSpecs.status_of_thread_with_uncaught_exception.stop?.should == true
  end

  it "describes a dying running thread" do
    ThreadSpecs.status_of_dying_running_thread.stop?.should == false
  end

  not_compliant_on :maglev do # Maglev deadlock or infinite loop
   it "describes a dying sleeping thread" do
     ThreadSpecs.status_of_dying_sleeping_thread.stop?.should == true
   end
  end

  quarantine! do
  it "reports aborting on a killed thread" do
   not_compliant_on :maglev do 
    ThreadSpecs.status_of_aborting_thread.stop?.should == false
   end
   deviates_on :maglev do 
    ThreadSpecs.status_of_aborting_thread.stop?.should == true # Maglev bug
   end
  end
  end
end
