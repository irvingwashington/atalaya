# frozen_string_literal: true

module Atalaya
  module Visors
    class Puma
      def initialize(config:)
        @config = config
      end

      def call
        return {} unless defined?(::Puma)
        {
          puma: {
            server: server_info
          }
        }
      end

      private

      def base_object
        @base_object ||= ::Puma.instance_variable_get('@get_stats')
      end

      def server
        base_object&.instance_variable_get('@server')
      end

      def server_info
        if base_object.class == ::Puma::Single
          {
            mode: :single,
            backlog: server&.backlog || 0,
            running: server&.running || 0,
            max_threads: server&.max_threads || 0,
            pool_capacity: server&.pool_capacity || 0,
          }
        elsif base_object.class == ::Puma::Cluster
          {
            mode: :cluster,
            workers: base_object&.instance_variable_get('@options').try(:[], :workers)
          }
        end
      end
    end
  end
end
