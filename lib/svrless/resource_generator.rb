# frozen_string_literal: true

require "svrless"

module ResourceGenerator
  module ClassMethods
    DEFAULT_ACTIONS = %i[create show update destroy].freeze

    def resources(*args)
      generate_svrless_controller
      generate_cloudformation(klasses: args, actions: DEFAULT_ACTIONS)
      generate_function_files(klasses: args, actions: DEFAULT_ACTIONS)
    end

    def generate_cloudformation(klasses:, actions:)
      output = File.open("template.yaml", "w")
      output << CloudFormation::MainGenerator.new(klasses: klasses, actions: actions).representation
      output.close
    end

    def plural_klass_name(klass)
      klass.to_s.pluralize
    end

    def full_klass_name(klass)
      klass.to_s.camelize.pluralize
    end

    def generate_function_files(klasses:, actions:)
      klasses.each do |klass|
        generate_function_file(klass: klass, actions: actions)
      end
    end

    def generate_function_file(klass:, actions:)
      Dir.mkdir("app") unless Dir.exist?("app")
      Dir.mkdir("app/functions") unless Dir.exist?("app/functions")
      unless Dir.exist?("app/functions/#{plural_klass_name(klass)}")
        Dir.mkdir("app/functions/#{plural_klass_name(klass)}")
      end
      FileUtils.touch("app/functions/#{plural_klass_name(klass)}/controller.rb")
      File.open("app/functions/#{plural_klass_name(klass)}/controller.rb", "w") do |f|
        f.write "require 'svrless_controller'"
        f.write "\n"
        f.write "\n"
        f.write "class #{full_klass_name(klass)} < SvrlessController"
        f.write "\n"
        actions.each_with_index do |method, index|
          f.write "  def self.#{method}(event:, context:)\n"
          f.write "    {\n"
          f.write "      statusCode: 200,\n"
          f.write "      body: { hello: 'world' }.to_json\n"
          f.write "    }\n"
          f.write "  end\n"
          f.write "\n" unless actions.size == index + 1
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
