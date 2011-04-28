module ProcSpecs

 not_compliant_on :maglev do
  def self.new_proc_in_method
    Proc.new
  end
 end

 deviates_on :maglev do
  def self.new_proc_in_method(&block)
    Proc.new(&block)  # must pass block explicitly
  end
 end

  def self.new_proc_from_amp(&block)
    block
  end

  class ProcSubclass < Proc
  end

 not_compliant_on :maglev do
  def self.new_proc_subclass_in_method
    ProcSubclass.new
  end
 end
 deviates_on :maglev do
  def self.new_proc_subclass_in_method(&block)
    ProcSubclass.new(&block) # must pass block explicitly
  end
 end

  class MyProc < Proc
  end

  class MyProc2 < Proc
    def initialize(a, b)
      @first = a
      @second = b
    end

    attr_reader :first, :second
  end
end
