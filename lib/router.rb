require_relative 'route'
require 'byebug'

module RailsLite

  module RoutesExtendable
    def extendable_actions(*protocal_methods)
      protocal_methods.each do |protocal_method|
        define_method(protocal_method) do |pattern, controller_class, action_name|
          add_route(pattern, protocal_method, controller_class, action_name)
        end
      end
    end
  end

  class Router
    extend RoutesExtendable
    attr_accessor :routes

    def initialize
      @routes = []
    end

    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(pattern, method, controller_class, action_name)
    end

    extendable_actions :get, :post, :put, :delete

    def draw(&proc)
      self.instance_eval(&proc)
    end

    def match(req)
      @routes.find { |route| route.matches?(req) }
    end

    def run(req, res)
      route = match(req)
      if route
        route.run(req, res)
      else
        res.status = 404
      end
    end

    def all_routes
      @routes.map { |route| route.to_s }.join(" | ")
    end
  end

end
