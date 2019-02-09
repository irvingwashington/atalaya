module Atalaya
  module Visors
    class Process
      def initialize(config:)
        @config = config
      end

      def call
        {
          process: {
            process_id: ::Process.pid,
            threads: thread_stats,
          }
        }
      end

      private
      attr_reader :config

      def thread_stats
        list = Thread.list
        {
          count: list.size,
          statuses: list.map(&:status),
          backtraces: list.map { |th| th.backtrace[0] }
        }
      end
    end
  end
end
