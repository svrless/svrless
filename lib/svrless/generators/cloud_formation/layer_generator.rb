# frozen_string_literal: true

require "svrless"

module CloudFormation
  # Generates a hash representation of a AWS::Serverless::LayerVersion
  class LayerGenerator
    # TODO: allow naming overrides via initialize

    def hash_representation
      {
        svrless_layer: {
          type: "AWS::Serverless::LayerVersion",
          properties: hash_properties
        }
      }
    end

    private

    def hash_properties
      {
        layer_name: "svrless-shared-layer",
        description: "SVRLESS shared logic",
        content_uri: "app/shared/.",
        compatible_runtimes: ["ruby2.7"]
      }
    end
  end
end