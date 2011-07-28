require File.expand_path('../../../spec_helper', __FILE__)

require 'rbconfig'

# Generate a version.h file for specs to use
File.open File.expand_path("../ext/rubyspec_version.h", __FILE__), "w" do |f|
  # Yes, I know CONFIG variables exist for these, but
  # who knows when those could be removed without warning.
  major, minor, teeny = RUBY_VERSION.split(".")
  f.puts "#define RUBY_VERSION_MAJOR  #{major}"
  f.puts "#define RUBY_VERSION_MINOR  #{minor}"
  f.puts "#define RUBY_VERSION_TEENY  #{teeny}"
end

CAPI_RUBY_SIGNATURE = "#{RUBY_NAME}-#{RUBY_VERSION}"

def compile_extension(path, name)
  # TODO use rakelib/ext_helper.rb?
  arch_hdrdir = nil
  ruby_hdrdir = nil

  if RUBY_NAME == 'rbx'
    hdrdir = Rubinius::HDR_PATH
  elsif RUBY_NAME =~ /^ruby/
    if hdrdir = RbConfig::CONFIG["rubyhdrdir"]
      arch_hdrdir = File.join hdrdir, RbConfig::CONFIG["arch"]
      ruby_hdrdir = File.join hdrdir, "ruby"
    else
      hdrdir = RbConfig::CONFIG["archdir"]
    end
  elsif RUBY_NAME == 'jruby'
    require 'mkmf'
    hdrdir = $hdrdir
  elsif RUBY_NAME == 'maglev'
    mag = ENV['MAGLEV_HOME']
    hdrdir = "#{mag}/lib/ruby/1.8/include"  
  else
    raise "Don't know how to build C extensions with #{RUBY_NAME}"
  end

  ext       = File.join(path, "#{name}_spec")
  source    = "#{ext}.c"
  obj       = "#{ext}.o"
  lib       = "#{ext}.#{RbConfig::CONFIG['DLEXT']}"
  signature = "#{ext}.sig"

  ruby_header     = File.join(hdrdir, "ruby.h")
  rubyspec_header = File.join(path, "rubyspec.h")
  mri_header      = File.join(path, "mri.h")

  return lib if File.exists?(signature) and
                IO.read(signature).chomp == CAPI_RUBY_SIGNATURE and
                File.exists?(lib) and File.mtime(lib) > File.mtime(source) and
                File.mtime(lib) > File.mtime(ruby_header) and
                File.mtime(lib) > File.mtime(rubyspec_header) and
                File.mtime(lib) > File.mtime(mri_header)

  # avoid problems where compilation failed but previous shlib exists
  File.delete lib if File.exists? lib

  if RUBY_NAME == 'maglev'
    plat = RUBY_PLATFORM
    if plat == 'x86_64-linux'
      cc = 'gcc'
    elsif plat == 'sparc-solaris' || plat == 'x86_64-solaris'
      cc = "/opt/sunstudio12.1/bin/cc"   # maglev x86 solaris
    else 
      cc = RbConfig::CONFIG["CC"]
    end
    cflags = "-m64 -fPIC -g"
  else
    cc        = RbConfig::CONFIG["CC"]
    cflags    = (ENV["CFLAGS"] || RbConfig::CONFIG["CFLAGS"]).dup
  end

  cflags   += " -fPIC" unless cflags.include?("-fPIC")
  incflags  = "-I#{path} -I#{hdrdir}"
  incflags << " -I#{arch_hdrdir}" if arch_hdrdir
  incflags << " -I#{ruby_hdrdir}" if ruby_hdrdir

  cmd = "#{cc} #{incflags} #{cflags} -c #{source} -o #{obj}"
  puts "EXECUTING #{cmd}"
  output = `#{cmd}` 

  if $?.exitstatus != 0 or !File.exists?(obj)
    puts "ERROR:\n#{output}"
    raise "Unable to compile \"#{source}\""
  end
  if output.index('warning')
    # C code of specs should compile without warnings
    puts "WARNINGS:\n#{output}"
    raise "Warnings in compile \"#{source}\""
  end   

  libpath   = "-L#{path}"
  if RUBY_NAME == 'maglev'
    ldshared = "#{cc} -shared"
    libs = "-lrt -ldl -lm -lc"  
    dldflags = "-m64 -L."   
  else
    ldshared  = RbConfig::CONFIG["LDSHARED"]
    libs      = RbConfig::CONFIG["LIBS"]
    dldflags  = RbConfig::CONFIG["DLDFLAGS"]
  end

  cmd = `#{ldshared} #{obj} #{libpath} #{dldflags} #{libs} -o #{lib}`
  puts "EXECUTING #{cmd}"
  output = `#{cmd}`

  if $?.exitstatus != 0
    puts "ERROR:\n#{output}"
    raise "Unable to link \"#{source}\""
  end

  File.open(signature, "w") { |f| f.puts CAPI_RUBY_SIGNATURE }

  lib
end

def load_extension(name)
  path = File.join(File.dirname(__FILE__), 'ext')

  ext = compile_extension path, name
  require ext
end

# Constants
CAPI_SIZEOF_LONG = [0].pack('l!').size
