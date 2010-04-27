require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

# On Ruby < 1.9 #methods returns an Array of Strings
ruby_version_is ""..."1.9" do
  describe "Kernel#methods" do
    it "returns singleton methods defined by obj.meth" do
      KernelSpecs::Methods.methods(false).should include("ichi")
    end

    it "returns singleton methods defined in 'class << self'" do
      KernelSpecs::Methods.methods(false).should include("san")
    end

#   it "returns private singleton methods defined by obj.meth" do
#     KernelSpecs::Methods.methods(false).should include("shi")  # maglev fails , shi is private
#   end

    it "returns singleton methods defined in 'class << self' when it follows 'private'" do
      KernelSpecs::Methods.methods(false).should include("roku")
    end

    it "does not return private singleton methods defined in 'class << self'" do #
      KernelSpecs::Methods.methods(false).should_not include("shichi")
    end

    it "returns the publicly accessible methods of the object" do
      meths =  (mm = KernelSpecs::Methods).methods(false)
      meths.should include("hachi", "ichi", "juu", "juu_ichi",
                           "juu_ni", "roku", "san", "shi")

      KernelSpecs::Methods.new.methods(false).should == []
    end

    it "returns the publicly accessible methods in the object, its ancestors and mixed-in modules" do
      meths = (mm = KernelSpecs::Methods).methods(false) & KernelSpecs::Methods.methods
      meths.should include("hachi", "ichi", "juu", "juu_ichi",
                           "juu_ni", "roku", "san", "shi")

      mb = (inst = KernelSpecs::Methods.new).methods
      mb.should include("ku")
      mb.should include("ni")
      mb.should include("juu_san")
    end

    it "returns methods added to the metaclass through extend" do #
      inst = (mm = KernelSpecs::Methods).new
      inst.methods.should_not include("peekaboo")
      inst.extend(KernelSpecs::Methods::MetaclassMethods)
      inst.methods.should include("peekaboo")
    end

    it "does not return undefined singleton methods defined by obj.meth" do #
      o = KernelSpecs::Child.new
      def o.single; end
      o.methods.should include("single")

      class << o; self; end.send :undef_method, :single
      o.methods.should_not include("single")
    end

    it "does not return superclass methods undefined in the object's class" do #
      KernelSpecs::Child.new.methods.should_not include("parent_method")
    end

    it "does not return superclass methods undefined in a superclass" do #
      KernelSpecs::Grandchild.new.methods.should_not include("parent_method")
    end

    it "does not return included module methods undefined in the object's class" do #
      KernelSpecs::Grandchild.new.methods.should_not include("parent_mixin_method")
    end
  end
end

# On MRI >= 1.9 #methods returns an Array of Symbols.
ruby_version_is "1.9" do
  describe "Kernel#methods" do
    it "returns singleton methods defined by obj.meth" do
      KernelSpecs::Methods.methods(false).should include(:ichi)
    end

    it "returns singleton methods defined in 'class << self'" do
      KernelSpecs::Methods.methods(false).should include(:san)
    end

    it "returns private singleton methods defined by obj.meth" do
      KernelSpecs::Methods.methods(false).should include(:shi)
    end

    it "returns singleton methods defined in 'class << self' when it follows 'private'" do
      KernelSpecs::Methods.methods(false).should include(:roku)
    end

    it "does not return private singleton methods defined in 'class << self'" do
      KernelSpecs::Methods.methods(false).should_not include(:shichi)
    end

    it "returns the publicly accessible methods of the object" do
      meths =  KernelSpecs::Methods.methods(false)
      meths.should include(:hachi, :ichi, :juu, :juu_ichi,
                           :juu_ni, :roku, :san, :shi)

      KernelSpecs::Methods.new.methods(false).should == []
    end

    it "returns the publicly accessible methods in the object, its ancestors and mixed-in modules" do
      meths = KernelSpecs::Methods.methods(false) & KernelSpecs::Methods.methods
      meths.should include(:hachi, :ichi, :juu, :juu_ichi,
                           :juu_ni, :roku, :san, :shi)

      KernelSpecs::Methods.new.methods.should include(:ku, :ni, :juu_san)
    end

    it "returns methods added to the metaclass through extend" do
      meth = KernelSpecs::Methods.new
      meth.methods.should_not include(:peekaboo)
      meth.extend(KernelSpecs::Methods::MetaclassMethods)
      meth.methods.should include(:peekaboo)
    end

    it "does not return undefined singleton methods defined by obj.meth" do
      o = KernelSpecs::Child.new
      def o.single; end
      o.methods.should include(:single)

      class << o; self; end.send :undef_method, :single
      o.methods.should_not include(:single)
    end

    it "does not return superclass methods undefined in the object's class" do
      KernelSpecs::Child.new.methods.should_not include(:parent_method)
    end

    it "does not return superclass methods undefined in a superclass" do
      KernelSpecs::Grandchild.new.methods.should_not include(:parent_method)
    end

    it "does not return included module methods undefined in the object's class" do
      KernelSpecs::Grandchild.new.methods.should_not include(:parent_mixin_method)
    end
  end
end
