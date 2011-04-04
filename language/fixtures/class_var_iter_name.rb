
  it "allows a class variable as an iterator name" do  
    m = [1,2,3]
    n = 0
    for @@var in m
      n += 1
    end
    @@var.should == 3
    n.should == 3
    nil.pause
  end

