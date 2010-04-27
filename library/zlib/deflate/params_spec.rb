require File.expand_path('../../../../spec_helper', __FILE__)
require 'zlib'

describe 'Zlib::Deflate#params' do
  ruby_bug '239', '1.9.0' do
  it 'changes the deflate parameters' do
    data = 'abcdefghijklm'

    d = Zlib::Deflate.new Zlib::NO_COMPRESSION, Zlib::MAX_WBITS,
    Zlib::DEF_MEM_LEVEL, Zlib::DEFAULT_STRATEGY

    d << data.slice!(0..10)
    d.params Zlib::BEST_COMPRESSION, Zlib::DEFAULT_STRATEGY
    d << data

    d.finish.should ==
      "x\001\000\v\000\364\377abcdefghijk\000\000\000\377\377\313\311\005\000#\364\005<"
  end
  end
end

