# frozen_string_literal: true
require 'json'

module Atalaya
  class App
    extend Forwardable

    HEADERS = {'Content-Type' => 'application/json'}

    def initialize(config: Config.new)
      @config = config
    end

    def call(_env)
      [200, HEADERS, [serialize(Visors.merged_visors_output(config))]]
    rescue => e
      p e.backtrace
      [500, HEADERS, [serialize(error: e)]]
    end

    private
    attr_reader :config

    def serialize(any_object)
      JSON.dump(any_object)
    end
  end
end
