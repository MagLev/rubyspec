require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/common', __FILE__)

#describe "NoMethodError.new" do
#   Maglev constructor not implemented yet
# it "allows passing method args" do
#   NoMethodError.new("msg","name","args").args.should == "args"
# end
#end

describe "NoMethodError#args" do
  it "returns an empty array if the caller method had no arguments" do
    got = false # Maglev debugging
    begin
      NoMethodErrorSpecs::NoMethodErrorB.new.foo
    rescue Exception => e
      e.args.should == []
      got = true
    end
    got.should == true
  end

  it "returns an array with the same elements as passed to the method" do
    begin
      a = NoMethodErrorSpecs::NoMethodErrorA.new
      NoMethodErrorSpecs::NoMethodErrorB.new.foo(1,a)
    rescue Exception => e
      e.args.should == [1,a]
      e.args[1].object_id.should == a.object_id
    end
  end
end

describe "NoMethodError#message" do
  it "for an undefined method match /undefined method/" do
    begin
      NoMethodErrorSpecs::NoMethodErrorD.new.foo
    rescue Exception => e
      e.should be_kind_of(NoMethodError)
    end
  end

  it "for an protected method match /protected method/" do
    got = false
    begin
      NoMethodErrorSpecs::NoMethodErrorC.new.a_protected_method
    rescue Exception => e
      e.should be_kind_of(NoMethodError)
      got = true
    end
    got.should == true
  end

  not_compliant_on :rubinius, :maglev  do
    it "for private method match /private method/" do
      begin
        NoMethodErrorSpecs::NoMethodErrorC.new.a_private_method
      rescue Exception => e
        e.should be_kind_of(NoMethodError)
        e.message.match(/private method/).should_not == nil
      end
    end
  end
end
