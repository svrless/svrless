# frozen_string_literal: true

require "svrless"

module CloudFormation
  # Responsible for generating a hash which will eventually look like this:
  # Create:
  #   Type: Api
  #   Properties:
  #     Method: post
  #     Path: "/posts"
  #
  # Input: klass: Class, action: :show
  # Input: klass: Post, action: :update
  class EventGenerator
    attr_accessor :klass, :action

    def initialize(klass:, action:)
      @klass = klass
      @action = action
    end

    def hash_representation
      {
        "#{@action}": {
          type: "Api",
          properties: {
            method: http_method,
            path: api_path
          }
        }
      }
    end

    def http_method
      case @action
      when :create
        "post"
      when :show
        "get"
      when :update
        "put"
      else
        "delete"
      end
    end

    def api_path
      return "/#{restify_klass_name}" if @action == :create

      "/#{restify_klass_name}/{id}"
    end

    def restify_klass_name
      @klass.to_s.underscore.pluralize.dasherize
    end
  end
end
