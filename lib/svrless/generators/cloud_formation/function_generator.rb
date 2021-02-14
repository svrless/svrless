# frozen_string_literal: true

require "svrless"

require_relative "event_generator"

module CloudFormation
  # Responsible for generating a hash which will eventually look like this:
  class FunctionGenerator
    attr_accessor :klass, :actions

    def initialize(klass:, actions:)
      @klass = klass
      @actions = actions
    end

    def hash_representation
      {
        "#{plural_klass_name}_controller": {
          type: "AWS::Serverless::Function",
          properties: properties_hash
        }
      }
    end

    private

    def properties_hash
      {
        code_uri: "app/functions/#{plural_klass_name}",
        events: events_hash,
        function_name: "#{plural_klass_name}_controller".capitalize.camelize,
        handler: "controller.#{klass_name}.router",
        Layers: [{ Ref: "SvrlessLayer" }],
        runtime: "ruby2.7"
      }
    end

    def events_hash
      hash = {}
      @actions.each do |action|
        hash.merge! EventGenerator.new(klass: @klass, action: action).hash_representation
      end
      hash
    end

    def plural_klass_name
      @klass.to_s.pluralize.underscore
    end

    def klass_name
      @klass.to_s.camelize.pluralize
    end
  end
end
