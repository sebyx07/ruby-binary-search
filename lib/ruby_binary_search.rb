# frozen_string_literal: true

require 'set'
require 'singleton'

Dir[File.join(__dir__, 'binary_search', '**', '*.rb')].each { |file| require file }

module BinarySearch
  class Error < StandardError; end
end
