module Atalaya
  module Visors
    VISORS = [Process, VM, Puma, Rails].freeze

    def self.merged_visors_output(config)
      VISORS.each_with_object({}) do |visor_klass, visors_output|
        visors_output.merge!(visor_klass.new(config: config).call)
      end
    end
  end
end
