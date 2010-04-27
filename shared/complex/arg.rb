describe :complex_arg, :shared => true do
  it "returns the argument -- i.e., the angle from (1, 0) in the complex plane" do
    TwoPi = 2 * Math::PI
    (Complex(1, 0).send(@method) % TwoPi).should be_close(0, TOLERANCE)
    (Complex(0, 2).send(@method) % TwoPi).should be_close(Math::PI * 0.5, TOLERANCE)
    (Complex(-100, 0).send(@method) % TwoPi).should be_close(Math::PI, TOLERANCE)
    tp = TwoPi
    (c = (b = (a = Complex(0, -75.3)).send(@method)) % TwoPi).should be_close((px = Math::PI * 1.5), (tx = TOLERANCE))
  end
end
