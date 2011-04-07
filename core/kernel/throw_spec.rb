require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Kernel.throw" do
  it "transfers control to the end of the active catch block waiting for symbol" do
    catch(:blah) do
      :value
      throw :blah
      fail("throw didn't transfer the control")
    end.should be_nil
  end

  it "transfers control to the innermost catch block waiting for the same sympol" do
    one = two = three = 0
    catch :duplicate do
      catch :duplicate do
        catch :duplicate do
          one = 1
          throw :duplicate
        end
        two = 2
        throw :duplicate
      end
      three = 3
      throw :duplicate
    end
    [one, two, three].should == [1, 2, 3]
  end

  it "sets the return value of the catch block to nil by default" do
    res = catch :blah do
      throw :blah
    end
    res.should == nil
  end

  it "sets the return value of the catch block to a value specified as second parameter" do
    res = catch :blah do
      throw :blah, :return_value
    end
    res.should == :return_value
  end

  ruby_version_is ""..."1.9" do
    it "raises a NameError if there is no catch block for the symbol" do
      lambda { throw :blah }.should raise_error(NameError)
    end
  end  

  ruby_version_is "1.9" do
    it "raises an ArgumentError if there is no catch block for the symbol" do
      lambda { throw :blah }.should raise_error(ArgumentError)
    end
  end  

  it "raises ArgumentError if 3 or more arguments provided" do
    lambda {
      catch :blah do
        throw :blah, :return_value, 2
      end
    }.should raise_error(ArgumentError)

    lambda {
      catch :blah do
        throw :blah, :return_value, 2, 3, 4, 5
      end
    }.should raise_error(ArgumentError)
  end

  ruby_version_is ""..."1.9" do
    it "raises TypeError if the first argument is not a symbol" do
      lambda {
        catch :blah do
          throw Object.new
        end
      }.should raise_error(TypeError)
    end
  end

  ruby_version_is "1.9" do
    it "can throw an object" do
      lambda {
        obj = Object.new
        catch obj do
          throw obj
        end
      }.should_not raise_error(NameError)
    end
  end
end

describe "Kernel#throw" do
 not_compliant_on :maglev do #  not private yet
  it "is a private method" do
    Kernel.should have_private_instance_method(:throw)
  end
 end
end
