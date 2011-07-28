require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Thread#inspect" do
  it "can check it's own status" do
    ThreadSpecs.status_of_current_thread.inspect.should include('run')
  end

  it "describes a running thread" do
   not_compliant_on :maglev do 
    ThreadSpecs.status_of_running_thread.inspect.should include('run')
   end
   deviates_on :maglev do 
    # Maglev,  only the current thread is running
    ThreadSpecs.status_of_running_thread.inspect.should include('sleep')
   end
  end

  it "describes a sleeping thread" do
    ThreadSpecs.status_of_sleeping_thread.inspect.should include('sleep')
  end

  it "describes a blocked thread" do
    ThreadSpecs.status_of_blocked_thread.inspect.should include('sleep')
  end

  it "describes a completed thread" do
   not_compliant_on :maglev do
    ThreadSpecs.status_of_completed_thread.inspect.should include('dead')
   end
   deviates_on :maglev do
    ThreadSpecs.status_of_completed_thread.inspect.should include('false') # Maglev bug
   end
  end

  it "describes a killed thread" do
   not_compliant_on :maglev do
    ThreadSpecs.status_of_killed_thread.inspect.should include('dead')
   end
   deviates_on :maglev do
    x = ThreadSpecs.status_of_killed_thread.inspect 
    x.should include('nil') # Maglev bug, was 'dead'
   end
  end

  it "describes a thread with an uncaught exception" do
   not_compliant_on :maglev do
    ThreadSpecs.status_of_thread_with_uncaught_exception.inspect.should include('dead')
   end
   deviates_on :maglev do
    ThreadSpecs.status_of_thread_with_uncaught_exception.inspect.should include('false') # Maglev bug
   end
  end


  ruby_version_is ""..."1.9" do
    it "describes a dying running thread" do
     not_compliant_on :maglev do
      ThreadSpecs.status_of_dying_running_thread.inspect.should include('aborting')
     end
     deviates_on :maglev do
      ThreadSpecs.status_of_dying_running_thread.inspect.should include('run')
     end
    end
  end

 not_compliant_on :maglev do # maglev error cannot resume a terminated process
  it "describes a dying sleeping thread" do
    ThreadSpecs.status_of_dying_sleeping_thread.status.should include('sleep')
  end
 end

  quarantine! do
  it "reports aborting on a killed thread" do
   not_compliant_on :maglev do
    ThreadSpecs.status_of_aborting_thread.inspect.should include('aborting')
   end
   deviates_on :maglev do
    ThreadSpecs.status_of_aborting_thread.inspect.should include('nil')
   end
  end
  end
end
