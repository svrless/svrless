# frozen_string_literal: true

require "svrless"
require_relative "layer_generator"
require_relative "function_generator"

module CloudFormation
  # The main outer shell of SAM template generators
  class MainGenerator
    AWS_TEMPLATE_VERSION = "2010-09-09"
    AWS_TRANSFORM_VERSION = "AWS::Serverless-2016-10-31"

    attr_accessor :klasses, :actions

    def initialize(klasses:, actions:)
      @klasses = klasses
      @actions = actions
    end

    def representation
      main_template_hash.deep_transform_keys { |k| k.to_s.capitalize.camelize }.to_yaml
    end

    def hash_representation
      main_template_hash
    end

    private

    def main_template_hash
      {
        a_w_s_template_format_version: AWS_TEMPLATE_VERSION,
        transform: AWS_TRANSFORM_VERSION,
        resources: resources_hash
      }
    end

    def resources_hash
      resources = {}
      resources.merge! function_hashes
      resources.merge! CloudFormation::LayerGenerator.new.hash_representation
      resources
    end

    def function_hashes
      functions = {}
      @klasses.each do |klass|
        functions.merge! CloudFormation::FunctionGenerator.new(klass: klass, actions: actions).hash_representation
      end
      functions
    end
  end
end
