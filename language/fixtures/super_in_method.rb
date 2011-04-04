  class Csup
    def a; "a"; end
    def b; "b"; end
    def c; "c"; end
  end
  class Csub < Csup
    [:a, :b].each do |name|
       define_method name do
         super()
       end
    end

  end


  it "supers up appropriate name even if used for multiple method names" do
    Csub.new.a.should == "a"
    Csub.new.b.should == "b"
    Csub.new.a.should == "a"
  end 

  # implicit arguments from a method defined with define_method not supported by maglev

  ruby_version_is "1.9" do
    it "can't be used with implicit arguments from a method defined with define_method" do
      true.should == false # spec needs more work
    end
  end

