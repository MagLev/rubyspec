  it "supers up appropriate name even if used for multiple method names" do
    sup = Class.new do
      def a; "a"; end
      def b; "b"; end
    end

    sub = Class.new(sup) do
      [:a, :b].each do |name|
        define_method name do
          super()
        end
      end
    end

    sub.new.a.should == "a"
    sub.new.b.should == "b"
    sub.new.a.should == "a"
  end 

  ruby_version_is ""..."1.9" do
    it "can be used with implicit arguments from a method defined with define_method" do
      sup = Class.new do
        def a; "a"; end
      end

      sub = Class.new(sup) do
        define_method :a do
          super
        end
      end

      sub.new.a.should == "a"
    end
  end
 

  ruby_version_is "1.9" do
    it "can't be used with implicit arguments from a method defined with define_method" do
      Class.new do
        define_method :a do
          super
        end.should raise_error(RuntimeError)
      end
    end
  end

