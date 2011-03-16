require File.expand_path('../../../spec_helper', __FILE__)

not_compliant_on :maglev do  # Class#dup not implemented
describe "Class#dup" do
  it "duplicates both the class and the singleton class" do
    klass = Class.new do
      def hello
        "hello"
      end
      
      def self.message
        "text"
      end
    end

    klass_dup = klass.dup
    
    klass_dup.message.should == "text"
    klass_dup.new.hello.should == "hello"
  end

  it "retains the correct ancestor chain for the singleton class" do
    super_klass = Class.new do
      def hello
        "hello"
      end
      
      def self.message
        "text"
      end
    end

    klass = Class.new(super_klass)
    klass_dup = klass.dup
    
    klass_dup.new.hello.should == "hello"
    klass_dup.message.should == "text"
  end
end
end
