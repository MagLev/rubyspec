describe :proc_call_block_args, :shared => true do
  it "can receive block arguments" do
    sel = @method
    pa = Proc.new {|b| b.send(@method)} 	 # maglev debugging edits
    pa.send(@method) {1 + 1}.should == 2
    la = lambda {|b| b.send(@method)}
    la.send(@method) {1 + 1}.should == 2
    pb = proc {|b| b.send(@method)}
    pb.send(@method) {1 + 1}.should == 2
  end
end
