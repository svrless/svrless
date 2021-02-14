require "minitest/autorun"

require_relative "../lib/svrless/generators/cloud_formation/main_generator"
require_relative "test_generate"

class MainGeneratorTest < Minitest::Test
  def test_post_generated_hash
    generator = CloudFormation::MainGenerator.new(klasses: [::TestGenerate], actions: [:create, :update, :show, :destroy])
    assert_equal(generated_main_hash, generator.hash_representation)
  end

  def generated_main_hash
    {
      a_w_s_template_format_version: "2010-09-09",
      transform: "AWS::Serverless-2016-10-31",
      resources: {
        test_generates_controller: {
          type: "AWS::Serverless::Function",
          properties: {
            code_uri: "app/functions/test_generates",
            events: {
              create: {
                type: "Api",
                properties: {
                  method: "post",
                  path: "/test-generates"
                }
              },
              update: {
                type: "Api",
                properties: {
                  method: "put",
                  path: "/test-generates/{id}"
                }
              },
              show: {
                type: "Api",
                properties: {
                  method: "get",
                  path: "/test-generates/{id}"
                }
              },
              destroy: {
                type: "Api",
                properties: {
                  method: "delete",
                  path: "/test-generates/{id}"
                }
              }
            },
            function_name: "TestGeneratesController",
            handler: "controller.TestGenerate.router",
            Layers: [{ Ref: "SvrlessLayer" }],
            runtime: "ruby2.7"
          }
        },
        svrless_layer: {
          type: "AWS::Serverless::LayerVersion",
          properties: {
            layer_name: "svrless-shared-layer",
            description: "SVRLESS shared logic",
            content_uri: "app/shared/.", compatible_runtimes: ["ruby2.7"]
          }
        }
      }
    }
  end
end
