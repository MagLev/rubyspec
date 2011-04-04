require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Thread#status" do
  it "can check it's own status" do
    ThreadSpecs.status_of_current_thread.status.should == 'run'
  end

  it "describes a running thread" do
   not_compliant_on :maglev do 
    ThreadSpecs.status_of_running_thread.status.should == 'run'
   end
   deviates_on :maglev do 
    ThreadSpecs.status_of_running_thread.status.should == 'sleep' # only current thread is 'run'
   end
  end

  it "describes a sleeping thread" do
    ThreadSpecs.status_of_sleeping_thread.status.should == 'sleep'
  end

  it "describes a blocked thread" do
    ThreadSpecs.status_of_blocked_thread.status.should == 'sleep'
  end

  it "describes a completed thread" do
    ThreadSpecs.status_of_completed_thread.status.should == false
  end

  it "describes a killed thread" do
   not_compliant_on :maglev do
    ThreadSpecs.status_of_killed_thread.status.should == false
   end
   deviates_on :maglev do
    ThreadSpecs.status_of_killed_thread.status.should == nil
   end
  end

  it "describes a thread with an uncaught exception" do
   not_compliant_on :maglev do
    ThreadSpecs.status_of_thread_with_uncaught_exception.status.should == nil
   end
   deviates_on :maglev do
    ThreadSpecs.status_of_thread_with_uncaught_exception.status.should == false 
   end
  end

  it "describes a dying running thread" do
    # ThreadSpecs.status_of_dying_running_thread.status.should == 'aborting'
    ThreadSpecs.status_of_dying_running_thread.status.should == 'run' # Maglev
  end

  not_compliant_on :maglev do #  Maglev, infinite loop , or deadlock
   it "describes a dying sleeping thread" do
     ThreadSpecs.status_of_dying_sleeping_thread.status.should == 'sleep'
   end
  end

  it "reports aborting on a killed thread" do
   not_compliant_on :maglev do
    ThreadSpecs.status_of_aborting_thread.status.should == 'aborting'
   end
   deviates_on :maglev do
    ThreadSpecs.status_of_aborting_thread.status.should == nil
   end
  end
end
