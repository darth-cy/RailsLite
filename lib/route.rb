module RailsLite
  class Route

    def initialize(pattern, method, controller_class, action_name)
      @pattern = pattern
      @method = method
      @controller_class = controller_class
      @action_name = action_name
    end

    def matches?(req)
      !!(req.path =~ @pattern) && req.request_method == @method.to_s.upcase
    end

    def run(req, res)
      if matches?(req)
        controller = @controller_class.new(req, res)
        controller.send :invoke_action, @action_name
      end
    end

    def to_s
      "#{@pattern} #{@method} #{@controller_class} #{@action_name}"
    end

    private
    attr_accessor :pattern, :method, :controller_class, :action_name
  end
end
