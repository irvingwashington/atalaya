module Atalaya
  module Visors
    class VM
      def initialize(config:)
        @config = config
      end

      def call
        {
          vm: {
            gc_stat: GC.stat,
            object_space: ObjectSpace.count_objects,
             # live_slots / (eden_pages * slots_per_page)
          }
        }
      end
    end
  end
end
