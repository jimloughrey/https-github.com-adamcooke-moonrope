module Moonrope
  class Controller
    
    attr_accessor :name, :actions, :befores
    attr_reader :base, :dsl
    
    def initialize(base, name, &block)
      @base = base
      @name = name
      @actions = {}
      @befores = []
      @dsl = Moonrope::DSL::ControllerDSL.new(self)
      @dsl.instance_eval(&block) if block_given?
    end
    
    def before_actions_for(action)
      @befores.select do |b|
        b.actions.empty? || b.actions.include?(action)
      end
    end
    
    def /(action)
      actions[action.to_sym]
    end
    
  end
end