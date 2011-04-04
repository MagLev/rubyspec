require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is ""..."1.9.1" do
  describe "Precision.included" do
    it "raises a TypeError when a class mixed with Precision does not specify induced_from" do
      class Foo ;include Precision ;end
     not_compliant_on :maglev do
      lambda { Foo.induced_from(1) }.should raise_error(TypeError)
     end
     deviates_on :maglev do
      lambda { Foo.induced_from(1) }.should raise_error(NoMethodError)
     end
    end

    it "doesn't raise a TypeError when a class mixed with Precision specifies induced_from" do
      class Foo
        include Precision
        def self.induced_from(obj)
          # nothing
        end
      end
      lambda { Foo.induced_from(1) }.should_not raise_error(TypeError)
    end
  end
end
