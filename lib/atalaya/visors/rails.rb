module Atalaya
  module Visors
    class Rails
      def initialize(config:)
        @config = config
      end

      def call
        return {} unless defined?(::Rails)
        {
          rails: {
            active_record: activerecord_stats,
            action_view: nil,
            action_mailer: nil,
            action_controller: nil,
          }
        }
      end

      private

      def activerecord_stats
        {
          active_connections_count: active_connections_count,
          pool_size: pool_size,
          prepared_statements_count: prepared_statements_count,
          prepared_statements: prepared_statements,
        }
      end

      def pool_size
        ActiveRecord::Base.connection_pool.size
      end

      def active_connections_count
        ActiveRecord::Base.connection_pool.connections.size
      end

      def prepared_statements_count
        ActiveRecord::Base.connection_pool.connections.map do |conn|
          conn.instance_variable_get('@statements').count
        end
      end

      def prepared_statements
        ActiveRecord::Base.connection_pool.connections.map do |conn|
          conn.instance_variable_get('@statements').send(:cache)
        end
      end
    end
  end
end
