# frozen_string_literal: true

require_relative "test_helper"

class SvrlessTest < Minitest::Test
  def test_has_a_version_number
    refute_nil ::Event::VERSION
  end
end
