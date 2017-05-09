module Service
  extend ActiveSupport::Concern

  module ClassMethods

    def call(*args)
      new(*args).call
    end

    def print(*args)
      new(*args).print
    end

    def initialize_with_parameter_assignment(*parameter_names, &block)
      parameter_names = *parameter_names
      attr_reader(*parameter_names)
      define_method :initialize do |*parameters|
        raise ArgumentError, "wrong number of arguments (given #{parameters.length}, expected #{parameter_names.length})" unless parameter_names.length == parameters.length
        parameter_names.each_with_index do |name, index|
          instance_variable_set(:"@#{name}", parameters[index])
        end
        instance_eval(&block) if block
      end
    end
  end
end
