module Moonrope
  class DSL
    
    def initialize(base)
      @base = base
    end
    
    #
    # Define a new global structure
    #
    def structure(name, &block)
      structure = Structures::Structure.new(@base, name)
      structure.dsl.instance_eval(&block)
      @base.structures << structure
    end
    
    #
    # Create a new controller or append actions to an existing controller
    #
    def controller(name, &block)
      existing = @base.controllers.select { |a| a.name == name }.first
      if existing
        controller = existing
      else
        controller = Controllers::Controller.new(@base, name)
      end
      controller.dsl.instance_eval(&block)
      @base.controllers << controller
    end
    
  end
end