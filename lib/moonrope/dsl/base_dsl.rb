module Moonrope
  module DSL
    class BaseDSL
      
      #
      # Initiaize a new BaseDSL
      #
      # @param base [Moonrope::Base]
      #
      def initialize(base)
        @base = base
      end
    
      #
      # Define a new structure
      #
      # @param name [Symbol] the name of the structure
      # @yield instance evals the block within the StructureDSL
      #
      def structure(name, &block)
        structure = Moonrope::Structure.new(@base, name)
        structure.dsl.instance_eval(&block) if block_given?
        @base.structures << structure
        structure
      end
    
      #
      # Define a new controller or append values to an existing
      # controller if it has already been defined.
      #
      # @param name [Symbol] the name of the controller
      # @yield instance evals the block within the ControllerDSL
      #
      def controller(name, &block)
        existing = @base.controllers.select { |a| a.name == name }.first
        if existing
          controller = existing
        else
          controller = Moonrope::Controller.new(@base, name)
        end
        controller.dsl.instance_eval(&block) if block_given?
        @base.controllers << controller
        controller
      end
    
      #
      # Set the authenticator for the API.
      #
      # @yield stores the block as the authenticator
      #
      def authenticator(&block)
        @base.authenticator = block
      end
      
      #
      # Set the default access check block.
      #
      # @yield stores the block as the access check
      #
      def default_access(&block)
        @base.default_access = block
      end
      
      #
      # Define a new helper in the global namespace
      #
      # @param name [Symbol] the name of the helper
      # @yield stores the block to execute for the helper
      #
      def helper(name, &block)
        helper_instance = Moonrope::Helper.new(name, nil, &block)
        @base.helpers << helper_instance
        helper_instance
      end
      
    end
  end
end
