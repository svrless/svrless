require "minitest/autorun"

require_relative "../lib/svrless/generators/cloud_formation/event_generator"
require_relative "test_generate"

class EventGeneratorTest < Minitest::Test
  def test_post_generated_hash
    generator = CloudFormation::EventGenerator.new(klass: ::TestGenerate, action: :create)
    assert_equal(generated_post_hash, generator.hash_representation)
  end

  def test_get_generated_hash
    generator = CloudFormation::EventGenerator.new(klass: ::TestGenerate, action: :show)
    assert_equal(generated_get_hash, generator.hash_representation)
  end

  def test_put_generated_hash
    generator = CloudFormation::EventGenerator.new(klass: ::TestGenerate, action: :update)
    assert_equal(generated_put_hash, generator.hash_representation)
  end

  def test_delete_generated_hash
    generator = CloudFormation::EventGenerator.new(klass: ::TestGenerate, action: :destroy)
    assert_equal(generated_delete_hash, generator.hash_representation)
  end

  def generated_post_hash
    {
      create: {
        type: "Api",
        properties: {
          method: "post",
          path: "/test-generates"
        }
      }
    }
  end

  def generated_get_hash
    {
      show: {
        type: "Api",
        properties: {
          method: "get",
          path: "/test-generates/{id}"
        }
      }
    }
  end

  def generated_put_hash
    {
      update: {
        type: "Api",
        properties: {
          method: "put",
          path: "/test-generates/{id}"
        }
      }
    }
  end

  def generated_delete_hash
    {
      destroy: {
        type: "Api",
        properties: {
          method: "delete",
          path: "/test-generates/{id}"
        }
      }
    }
  end
end
