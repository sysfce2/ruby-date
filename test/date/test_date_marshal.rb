# frozen_string_literal: true
require 'test/unit'
require 'date'

class TestDateMarshal < Test::Unit::TestCase

  def test_marshal
    d = Date.new
    m = Marshal.dump(d)
    d2 = Marshal.load(m)
    assert_equal(d, d2)
    assert_equal(d.start, d2.start)
    assert_instance_of(String, d2.to_s)

    d = Date.today
    m = Marshal.dump(d)
    d2 = Marshal.load(m)
    assert_equal(d, d2)
    assert_equal(d.start, d2.start)
    assert_instance_of(String, d2.to_s)

    d = DateTime.now
    m = Marshal.dump(d)
    d2 = Marshal.load(m)
    assert_equal(d, d2)
    assert_equal(d.start, d2.start)
    assert_instance_of(String, d2.to_s)

    d = Date.today
    a = d.marshal_dump
    d.freeze
    assert(d.frozen?)
    if defined?(FrozenError)
      assert_raise(FrozenError){d.marshal_load(a)}
    else
      assert_raise(RuntimeError){d.marshal_load(a)}
    end

    d = DateTime.now
    a = d.marshal_dump
    d.freeze
    assert(d.frozen?)
    if defined?(FrozenError)
      assert_raise(FrozenError){d.marshal_load(a)}
    else
      assert_raise(RuntimeError){d.marshal_load(a)}
    end
  end

end
