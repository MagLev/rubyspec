class FileStat
  # Maglev fixes to properly pass arguments
  def self.method_missing(method_id, *args)
    nargs = args.length 
    if nargs.equal?(0)
      raise TypeError, "expect at least one arg"
    end
    file = args[0]
    if nargs.equal?(1)
      File.lstat(file).send(method_id)
    elsif nargs.equal?(2)
      File.lstat(file).send(method_id, args[1])
    elsif nargs.equal?(3)
      File.lstat(file).send(method_id, args[1], args[2])
    else
      raise TypeError, "> 3 args not implemented yet"
      nil
    end
  end
end
