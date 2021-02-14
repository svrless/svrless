require "minitest/autorun"

require_relative "../lib/svrless/generators/cloud_formation/layer_generator"

class LayerGeneratorTest < Minitest::Test
  def test_post_generated_hash
    generator = CloudFormation::LayerGenerator.new
    assert_equal(generated_layer_hash, generator.hash_representation)
  end

  def generated_layer_hash
    {
      svrless_layer: {
        type: "AWS::Serverless::LayerVersion",
        properties: layer_properties_hash
      }
    }
  end

  def layer_properties_hash
    {
      layer_name: "svrless-shared-layer",
      description: "SVRLESS shared logic",
      content_uri: "app/shared/.",
      compatible_runtimes: ["ruby2.7"]
    }
  end
end
