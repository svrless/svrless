# frozen_string_literal: true

require "active_support/all"
require "yaml"

require_relative "svrless/version"
require_relative "svrless/resource_generator"
require_relative "svrless/generators/cloud_formation/main_generator"

module Svrless
  class Error < StandardError; end
end
