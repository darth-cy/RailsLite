require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'

require_relative "session"
require_relative "params"

module RailsLite

  class ControllerBase
    attr_reader :params, :session
    attr_reader :req, :res, :built_response

    def initialize(req, res, route_params = {})
      @req = req
      @res = res
      @session = Session.new(@req)
      @params = Params.new(@req, route_params)
    end

    def redirect_to(url)
      if already_built_response?
        raise
      end
      @res["location"] = url
      @res.status = 302

      @built_response = :redirected
      @session.store_session(@res)
    end

    def render(template_name)
      folder_name = "#{self.class}".underscore
      path = "views/#{folder_name}/#{template_name}.html.erb"
      htmls = File.read(path)
      render_content(htmls, "text/html")

      @built_response = :rendered
      @session.store_session(@res)
    end

    def render_content(content, content_type)
      if already_built_response?
        raise
      end
      @res.body = content
      @res.content_type = content_type

      @built_response = :rendered
      @session.store_session(@res)
    end

    def session
      @session ||= Session.new(@req)
    end

    def params
      @params ||= Param.new(@req)
    end

    def invoke_action(action_name)
      self.send action_name
    end

    private
    def already_built_response?
      !!@built_response
    end
  end
end
