describe "The unpacking splat operator (*)" do
 # Maglev fails
   it "when applied to a non-Array value attempts to coerce it to Array if the object respond_to?(:to_ary)" do
     obj = mock("pseudo-array")
     obj.should_receive(:to_ary).and_return([2, 3, 4])
     xx = [1, *obj]
     xx.should == [1, 2, 3, 4] 
   end

  it "when applied to a non-Array value uses it unchanged if it does not respond_to?(:to_ary)" do
    obj = Object.new
    obj.should_not respond_to(:to_ary)
    [1, *obj].should == [1, obj]
  end
end
