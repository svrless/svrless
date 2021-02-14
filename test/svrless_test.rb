# frozen_string_literal: true

require_relative "test_helper"
require_relative "test_route"

class SvrlessTest < Minitest::Test
  def test_has_a_version_number
    refute_nil ::Event::VERSION
  end

  def test_event_class
    TestRoute.new
    assert(true)
  end
end
