describe :struct_inspect, :shared => true do
  ruby_version_is "1.9" do
    it "returns a string representation without the class name for anonymous structs" do
      Struct.new(:a).new("").send(@method).should == '#<struct a="">'
    end
  end

  ruby_version_is ""..."1.9" do
    it "returns a string representation with the class name for anonymous structs" do
     not_compliant_on :maglev do
      Struct.new(:a).new("").send(@method).should =~ /#<struct #<Class:[^>]+> a=\"\">/
     end
     deviates_on :maglev do
      Struct.new(:a).new("").send(@method).should == '#<struct  a="">' # Maglev gives 1.9 style
     end
    end
  end
end
