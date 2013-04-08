require "minitest/autorun"

$:.unshift File.expand_path("~/Work/p4/zss/src/sexp_processor/dev/lib")

require "uby_interpreter"

class TestUbyInterpreter < MiniTest::Unit::TestCase
  attr_accessor :ri

  def setup
    self.ri = UbyInterpreter.new
  end

  def assert_eval exp, src, msg = nil
    assert_equal exp, ri.eval(src), msg
  end

  def define_fib
    assert_eval nil, <<-END
      def fib n
        if n <= 2 then
          1
        else
          fib(n-2) + fib(n-1)
        end
      end
    END
  end

  def test_sanity
    assert_eval 3, "3"
    assert_eval 7, "3 + 4"
  end

  def test_defn
    assert_eval nil, <<-EOM
      n = 24
      def double n
        2 * n
      end
    EOM

    assert_eval 42, "double(21)"
  end

  def test_fib
    define_fib

    assert_eval 8, "fib(6)"
  end

  def test_if
    assert_eval 42, "if true then 42 else 24 end"
  end

  def test_if_falsey
    assert_eval 24, "if nil   then 42 else 24 end"
    assert_eval 24, "if false then 42 else 24 end"
  end

  def test_lvar
    assert_eval 42, "x = 42; x"
  end

  def test_while_fib
    define_fib

    assert_eval 1+1+2+3+5+8+13+21+34+55, <<-EOM
      n = 1
      sum = 0
      while n <= 10
        sum += fib(n)
        n += 1
      end
      sum
    EOM
  end
end
