require 'activesupport'


module ActiveRecordLite

  class ControllerBase
    attr_reader :params, :session
    attr_reader :req, :res, :built_response

    def initialize(req, res, route_params = {})
      @req = req
      @res = res

    end

    def already_built_response?
      !!@built_response
    end

    def redirect_to(url)
      if already_built_response?
        raise
      end
      @res["location"] = url
      @res.status = 302
      @built_response = url
    end

    def render_content(content, content_type)
      if already_built_response?
        raise
      end
      @res.body = content
      @res.content_type = content_type
      @built_response = content
    end

    def render(template_name)

    end

    def initialize(req, res, route_params = {})
      @session = Phase4::Session.new(req)
      @params = Phase5::Params.new(req)
      @req = req
      @res = res
    end

    def render_content(content, content_type)
      @res.content_type = content_type
      @res.body = content
      if already_built_response?
        raise
      end
      @built_response = @res.body
      @session.store_session(@res)
    end

    # use this with the router to call action_name (:index, :show, :create...)
    def invoke_action(name)
      self.send name
    end
  end

  end
end
