describe :extract_range_matched, :shared => true do
  it "returns an instance of String when passed a String subclass" do
    cls = Class.new(String)
    sub = cls.new("abc")

    s = StringScanner.new(sub)
    s.scan(/\w{1}/)

    ch = s.send(@method)
   not_compliant_on :maglev do
    ch.should_not be_kind_of(cls)
    ch.should be_an_instance_of(String)
   end
   deviates_on :maglev do
    ch.should be_an_instance_of(cls)
   end
  end

 not_supported_on :maglev do # no taint propagation
  it "taints the returned String if the input was tainted" do
    str = 'abc'
    str.taint

    s = StringScanner.new(str)
    s.scan(/\w{1}/)
    s.send(@method).tainted?.should be_true
  end
 end
end
