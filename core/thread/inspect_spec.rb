require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Thread#inspect" do
  it "can check it's own status" do
    ThreadSpecs.status_of_current_thread.inspect.should include('run')
  end

  it "describes a running thread" do
    # Maglev,  only the current thread is running
    ThreadSpecs.status_of_running_thread.inspect.should include('sleep') # Maglev, was run
  end

  it "describes a sleeping thread" do
    ThreadSpecs.status_of_sleeping_thread.inspect.should include('sleep')
  end

  it "describes a blocked thread" do
    ThreadSpecs.status_of_blocked_thread.inspect.should include('sleep')
  end

  it "describes a completed thread" do
    ThreadSpecs.status_of_completed_thread.inspect.should include('false') # Maglev bug, was 'dead'
  end

  it "describes a killed thread" do
    x = ThreadSpecs.status_of_killed_thread.inspect 
    x.should include('nil') # Maglev bug, was 'dead'
  end

  it "describes a thread with an uncaught exception" do
    ThreadSpecs.status_of_thread_with_uncaught_exception.inspect.should include('false') # Maglev bug, was 'dead'
  end

  ruby_version_is ""..."1.9" do
    it "describes a dying running thread" do
      ThreadSpecs.status_of_dying_running_thread.inspect.should include('run') # Maglev, was 'aborting'
    end
  end

# Maglev, deadlock or infinite loop
# it "describes a dying sleeping thread" do
#   ThreadSpecs.status_of_dying_sleeping_thread.status.should include('run') # Maglev, was 'sleep'
# end

  it "reports aborting on a killed thread" do
    ThreadSpecs.status_of_aborting_thread.inspect.should include('nil') # Maglev, was aborting'
  end
end
