not_compliant_on :maglev do # sends of __callee__, __method__ not supported
 def f
   send(@method)
 end
end
deviates_on :maglev do
 def f
   __method__ 
 end
end
alias g f

describe :kernel___method__, :shared => true do

  it "returns the current method, even when aliased" do
    f.should == :f
  end

  it "returns the original name when aliased method" do
   not_compliant_on :maglev do
    g.should == :f
   end
   deviates_on :maglev do
    g.should == :g  # maglev returns aliased name
   end
  end

  it "returns the caller from blocks too" do
    not_compliant_on :maglev do 
      def h
        (1..2).map { send(@method) } 
      end
    end
    deviates_on :maglev do
      def h
        (1..2).map { __method__ }  # # maglev send of __method__ not supported
      end
    end
    h.should == [:h, :h]
  end

 not_compliant_on :maglev do
  it "returns the caller from define_method too" do 
    klass = Class.new {define_method(:f) {__method__}}
    klass.new.f.should == :f
  end

  it "returns the caller from block inside define_method too" do
    klass = Class.new {define_method(:f) { 1.times{break __method__}}}
    klass.new.f.should == :f
  end

  it "returns the caller from a define_method called from the same class" do
    class C
      define_method(:f) { 1.times{break __method__}}
      def g; f end
    end
    C.new.g.should == :f
  end
 end

  it "returns method name even from eval" do
    def h
      eval @method.to_s
    end
    h.should == :h
  end

  it "returns nil when not called from a method" do
    not_compliant_on :maglev do 
      send(@method).should == nil 
    end
    deviates_on :maglev do
      __method__.should == nil
    end
  end

end
