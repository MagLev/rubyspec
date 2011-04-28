require File.expand_path('../../../../spec_helper', __FILE__)
require 'set'

ruby_version_is "1.8.7" do
  describe "SortedSet#hash" do
    it "is static" do
      SortedSet[].hash.should == SortedSet[].hash
      SortedSet[1, 2, 3].hash.should == SortedSet[1, 2, 3].hash
      SortedSet["a", "b", "c"].hash.should == SortedSet["c", "b", "a"].hash

      SortedSet[].hash.should_not == SortedSet[1, 2, 3].hash
     not_compliant_on :maglev do
      SortedSet[1, 2, 3].hash.should_not == SortedSet["a", "b", "c"].hash
     end
     deviates_on :maglev do
      # maglev, hash a function of size
      SortedSet[1, 2, 3, 4].hash.should_not == SortedSet["a", "b", "c"].hash 
     end
    end
  end
end
