# frozen_string_literal: true

require "active_support/all"
require "yaml"

module Event
  module ClassMethods
    def events(*args, resource)
      raise StandardError, "Event: You need to supply at least one argument" if args.empty?

      events = args
      generate(events, resource)
    end

    def resource(args)
      resource = args
      events(:create, :show, :update, :destroy, resource)
      generate_function_files(:create, :show, :update, :destroy, resource)
      generate_svrless_controller
    end

    def generate(events, resource)
      puts "generating"
      # make_function_files
      output = File.open("template.yaml", "w")
      output << main_representation(events, resource)
      output.close
    end

    def main_representation(events, resource)
      {
        a_w_s_template_format_version: "2010-09-09",
        transform: "AWS::Serverless-2016-10-31",
        resources: resources_hash(events, resource)
      }.deep_transform_keys { |k| k.to_s.capitalize.camelize }.to_yaml
    end

    def resources_hash(events, resource)
      layer.merge(function_hash(events, resource))
    end

    def layer
      {
        svrless_layer: {
          type: "AWS::Serverless::LayerVersion",
          properties: {
            layer_name: "svrless-layer",
            description: "All the business logic should go in here",
            content_uri: "app/shared/.",
            compatible_runtimes: ["ruby2.7"]
          }
        }
      }
    end

    def function_hash(events, resource)
      {
        "#{plural_classname(resource)}_controller": {
          type: "AWS::Serverless::Function",
          properties: {
            code_uri: "app/functions/#{plural_classname(resource)}",
            events: hash_of_events(events, resource),
            function_name: "#{plural_classname(resource)}_controller".capitalize.camelize,
            handler: "controller.#{full_classname(resource)}.router",
            Layers: [{ Ref: "SvrlessLayer" }],
            runtime: "ruby2.7"
          }
        }
      }
    end

    def hash_of_events(events, resource)
      h = {}
      events.each do |event|
        h.merge!(
          {
            "#{event}": {
              type: "Api",
              properties: {
                method: method_from_event(event: event),
                path: path_from_event(event: event, resource: resource)
              }
            }
          }
        )
      end
      h
    end

    def plural_classname(resource)
      resource.to_s.pluralize
    end

    def method_from_event(event:)
      case event
      when :create
        "post"
      when :show
        "get"
      when :update
        "put"
      when :destroy
        "delete"
      end
    end

    def path_from_event(event:, resource:)
      case event
      when :create
        "/#{plural_classname(resource)}"
      when :show
        "/#{plural_classname(resource)}/{id}"
      when :update
        "/#{plural_classname(resource)}/{id}"
      when :destroy
        "/#{plural_classname(resource)}/{id}"
      end
    end

    def full_classname(resource)
      "#{plural_classname(resource)}_controller".camelize
    end

    def generate_function_files(*args, resource)
      Dir.mkdir("app") unless Dir.exist?("app")
      Dir.mkdir("app/functions") unless Dir.exist?("app/functions")
      unless Dir.exist?("app/functions/#{plural_classname(resource)}")
        Dir.mkdir("app/functions/#{plural_classname(resource)}")
      end
      FileUtils.touch("app/functions/#{plural_classname(resource)}/controller.rb")
      File.open("app/functions/#{plural_classname(resource)}/controller.rb", "w") do |f|
        f.write "require 'svrless_controller'"
        f.write "\n"
        f.write "\n"
        f.write "class #{full_classname(resource)} < SvrlessController"
        f.write "\n"
        args.each_with_index do |method, index|
          f.write "  def self.#{method}(event:, context:)\n"
          f.write "    {\n"
          f.write "      statusCode: 200,\n"
          f.write "      body: { hello: 'world' }.to_json\n"
          f.write "    }\n"
          f.write "  end\n"
          f.write "\n" unless args.size == index + 1
        end
        f.write  "end"
        f.write  "\n"
      end
    end

    def generate_svrless_controller
      Dir.mkdir("app") unless Dir.exist?("app")
      Dir.mkdir("app/shared") unless Dir.exist?("app/shared")
      Dir.mkdir("app/shared/ruby") unless Dir.exist?("app/shared/ruby")
      Dir.mkdir("app/shared/ruby/lib") unless Dir.exist?("app/shared/ruby/lib")
      File.open("app/shared/ruby/lib/svrless_controller.rb", "w") do |f|
        f.write "class SvrlessController\n"
        f.write "  def self.router(event:, context:)\n"
        f.write "    case event['httpMethod']\n"
        f.write "    when 'GET'\n"
        f.write "      show(event: event, context: context)\n"
        f.write "    when 'POST'\n"
        f.write "      create(event: event, context: context)\n"
        f.write "    when 'DELETE'\n"
        f.write "      destroy(event: event, context: context)\n"
        f.write "    else\n"
        f.write "      update(event: event, context: context)\n"
        f.write "    end\n"
        f.write "  end\n"
        f.write "end\n"
      end
    end
  end

  def self.included(klass)
    klass.extend ClassMethods
  end
end
