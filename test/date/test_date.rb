# frozen_string_literal: true
require 'test/unit'
require 'date'

class DateSub < Date; end
class DateTimeSub < DateTime; end

class TestDate < Test::Unit::TestCase
  def test_range_infinite_float
    today = Date.today
    r = today...Float::INFINITY
    assert_equal today, r.begin
    assert_equal Float::INFINITY, r.end
    assert_equal true, r.cover?(today+1)
    assert_equal false, r.cover?(today-1)
    r = (-Float::INFINITY)...today
    assert_equal(-Float::INFINITY, r.begin)
    assert_equal today, r.end
    assert_equal false, r.cover?(today+1)
    assert_equal true, r.cover?(today-1)
  end

  def test__const
    assert_nil(Date::MONTHNAMES[0])
    assert_equal('January', Date::MONTHNAMES[1])
    assert_equal(13, Date::MONTHNAMES.size)
    assert_equal('Sunday', Date::DAYNAMES[0])
    assert_equal(7, Date::DAYNAMES.size)

    assert_nil(Date::ABBR_MONTHNAMES[0])
    assert_equal('Jan', Date::ABBR_MONTHNAMES[1])
    assert_equal(13, Date::ABBR_MONTHNAMES.size)
    assert_equal('Sun', Date::ABBR_DAYNAMES[0])
    assert_equal(7, Date::ABBR_DAYNAMES.size)

    assert(Date::MONTHNAMES.frozen?)
    assert(Date::MONTHNAMES[1].frozen?)
    assert(Date::DAYNAMES.frozen?)
    assert(Date::DAYNAMES[0].frozen?)

    assert(Date::ABBR_MONTHNAMES.frozen?)
    assert(Date::ABBR_MONTHNAMES[1].frozen?)
    assert(Date::ABBR_DAYNAMES.frozen?)
    assert(Date::ABBR_DAYNAMES[0].frozen?)
  end

  def test_sub
    d = DateSub.new
    dt = DateTimeSub.new

    assert_instance_of(DateSub, d)
    assert_instance_of(DateTimeSub, dt)

    assert_instance_of(DateSub, DateSub.today)
    assert_instance_of(DateTimeSub, DateTimeSub.now)

    assert_equal('-4712-01-01', d.to_s)
    assert_equal('-4712-01-01T00:00:00+00:00', dt.to_s)

    d2 = d + 1
    assert_instance_of(DateSub, d2)
    d2 = d - 1
    assert_instance_of(DateSub, d2)
    d2 = d >> 1
    assert_instance_of(DateSub, d2)
    d2 = d << 1
    assert_instance_of(DateSub, d2)
    d2 = d.succ
    assert_instance_of(DateSub, d2)
    d2 = d.next
    assert_instance_of(DateSub, d2)
    d2 = d.italy
    assert_instance_of(DateSub, d2)
    d2 = d.england
    assert_instance_of(DateSub, d2)
    d2 = d.julian
    assert_instance_of(DateSub, d2)
    d2 = d.gregorian
    assert_instance_of(DateSub, d2)
    s = Marshal.dump(d)
    d2 = Marshal.load(s)
    assert_equal(d2, d)
    assert_instance_of(DateSub, d2)

    dt2 = dt + 1
    assert_instance_of(DateTimeSub, dt2)
    dt2 = dt - 1
    assert_instance_of(DateTimeSub, dt2)
    dt2 = dt >> 1
    assert_instance_of(DateTimeSub, dt2)
    dt2 = dt << 1
    assert_instance_of(DateTimeSub, dt2)
    dt2 = dt.succ
    assert_instance_of(DateTimeSub, dt2)
    dt2 = dt.next
    assert_instance_of(DateTimeSub, dt2)
    dt2 = dt.italy
    assert_instance_of(DateTimeSub, dt2)
    dt2 = dt.england
    assert_instance_of(DateTimeSub, dt2)
    dt2 = dt.julian
    assert_instance_of(DateTimeSub, dt2)
    dt2 = dt.gregorian
    assert_instance_of(DateTimeSub, dt2)
    s = Marshal.dump(dt)
    dt2 = Marshal.load(s)
    assert_equal(dt2, dt)
    assert_instance_of(DateTimeSub, dt2)
  end

  def test_eql_p
    d = Date.jd(0)
    d2 = Date.jd(0)
    dt = DateTime.jd(0)
    dt2 = DateTime.jd(0)

    assert_equal(d, d2)
    assert_not_equal(d, 0)

    assert_equal(dt, dt2)
    assert_not_equal(dt, 0)

    assert_equal(d, dt)
    assert_equal(d2, dt2)
  end

  def test_hash
    h = {}
    h[Date.new(1999,5,23)] = 0
    h[Date.new(1999,5,24)] = 1
    h[Date.new(1999,5,25)] = 2
    h[Date.new(1999,5,25)] = 9
    assert_equal(3, h.size)
    assert_equal(9, h[Date.new(1999,5,25)])
    assert_equal(9, h[DateTime.new(1999,5,25)])

    h = {}
    h[Date.new(3171505571716611468830131104691,2,19)] = 0
    assert_equal(true, h.key?(Date.new(3171505571716611468830131104691,2,19)))

    h = {}
    h[DateTime.new(1999,5,23)] = 0
    h[DateTime.new(1999,5,24)] = 1
    h[DateTime.new(1999,5,25)] = 2
    h[DateTime.new(1999,5,25)] = 9
    assert_equal(3, h.size)
    assert_equal(9, h[Date.new(1999,5,25)])
    assert_equal(9, h[DateTime.new(1999,5,25)])

    assert_instance_of(String, Date.new(1999,5,25).hash.to_s)
  end

  def test_freeze
    d = Date.new
    d.freeze
    assert_equal(true, d.frozen?)
    assert_instance_of(Integer, d.yday)
    assert_instance_of(String, d.to_s)
  end

  def test_submillisecond_comparison
    d1 = DateTime.new(2013, 12, 6, 0, 0, Rational(1, 10000))
    d2 = DateTime.new(2013, 12, 6, 0, 0, Rational(2, 10000))
    # d1 is 0.0001s earlier than d2
    assert_equal(-1, d1 <=> d2)
    assert_equal(0, d1 <=> d1)
    assert_equal(1, d2 <=> d1)
  end

  def test_infinity_comparison
    assert_equal(0, Float::INFINITY <=> Date::Infinity.new)
    assert_equal(0, Date::Infinity.new <=> Float::INFINITY)
    assert_equal(0, -Float::INFINITY <=> -Date::Infinity.new)
    assert_equal(0, -Date::Infinity.new <=> -Float::INFINITY)

    assert_equal(1, Float::INFINITY <=> -Date::Infinity.new)
    assert_equal(1, Date::Infinity.new <=> -Float::INFINITY)

    assert_equal(-1, -Float::INFINITY <=> Date::Infinity.new)
    assert_equal(-1, -Date::Infinity.new <=> Float::INFINITY)
  end

  def test_deconstruct_keys
    d = Date.new(1999,5,23)
    assert_equal({year: 1999, month: 5, day: 23, wday: 0, yday: 143}, d.deconstruct_keys(nil))
    assert_equal({year: 1999}, d.deconstruct_keys([:year, :century]))
    assert_equal(
      {year: 1999, month: 5, day: 23, wday: 0, yday: 143},
      d.deconstruct_keys([:year, :month, :day, :wday, :yday])
    )

    dt = DateTime.new(1999, 5, 23, 4, 20, Rational(1, 10000))

    assert_equal(
      {year: 1999, month: 5, day: 23, wday: 0, yday: 143,
       hour: 4, min: 20, sec: 0, sec_fraction: Rational(1, 10000), zone: "+00:00"},
      dt.deconstruct_keys(nil)
    )

    assert_equal({year: 1999}, dt.deconstruct_keys([:year, :century]))

    assert_equal(
      {year: 1999, month: 5, day: 23, wday: 0, yday: 143,
       hour: 4, min: 20, sec: 0, sec_fraction: Rational(1, 10000), zone: "+00:00"},
      dt.deconstruct_keys([:year, :month, :day, :wday, :yday, :hour, :min, :sec, :sec_fraction, :zone])
    )

    dtz = DateTime.parse('3rd Feb 2001 04:05:06+03:30')
    assert_equal({zone: '+03:30'}, dtz.deconstruct_keys([:zone]))
  end
end
