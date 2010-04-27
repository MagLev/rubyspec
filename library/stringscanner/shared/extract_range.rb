describe :extract_range, :shared => true do
  it "returns an instance of String when passed a String subclass" do
    cls = Class.new(String)
    sub = cls.new("abc")

    s = StringScanner.new(sub)
    ch = s.send(@method)
    # ch.should_not be_kind_of(cls)
    # ch.should be_an_instance_of(String)
    ch.should be_an_instance_of(cls)  # maglev deviation
  end

 not_compliant_on :maglev do
  it "taints the returned String if the input was tainted" do #
    str = 'abc'
    str.taint

    s = StringScanner.new(str)

    s.send(@method).tainted?.should be_true
    s.send(@method).tainted?.should be_true
    s.send(@method).tainted?.should be_true
  end
 end #
end
