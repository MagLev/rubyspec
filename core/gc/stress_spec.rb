require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "1.8.7" do
  describe "GC.stress" do
    after :each do
      # make sure that we never leave these tests in stress enabled GC!
      GC.stress = false
    end

    it "returns current status of GC stress mode" do
      GC.stress.should be_false
      GC.stress = true
      not_compliant_on :maglev do
        GC.stress.should be_true
      end
      deviates_on :maglev do
        # GC.stress has no effect
        GC.stress.should be_false  
      end
      GC.stress = false
      GC.stress.should be_false
    end
  end

  describe "GC.stress=" do
    after :each do
      GC.stress = false
    end

    it "sets the stress mode" do
      GC.stress = true    # maglev has no effect
      not_compliant_on :maglev do
        GC.stress.should be_true
      end
      deviates_on :maglev do
        # GC.stress has no effect
        GC.stress.should be_false  
      end
    end

  end
end
