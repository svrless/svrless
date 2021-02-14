require "minitest/autorun"

require_relative "../lib/svrless/generators/cloud_formation/function_generator"
require_relative 'test_generate'

class FunctionGeneratorTest < Minitest::Test
  def test_function_generated_hash
    generator = CloudFormation::FunctionGenerator.new(klass: TestGenerate, actions: [:show])
    assert_equal(generated_function_hash, generator.hash_representation)
  end

  def generated_function_hash
    {
      test_generates_controller: {
        type: "AWS::Serverless::Function",
        properties: {
          code_uri: "app/functions/test_generates",
          events: {
            show: {
              type: "Api",
              properties: {
                method: "get",
                path: "/test-generates/{id}"
              }
            }
          },
          function_name: "TestGeneratesController",
          handler: "controller.TestGenerate.router",
          Layers: [{ Ref: "SvrlessLayer" }],
          runtime: "ruby2.7"
        }
      }
    }
  end
end
