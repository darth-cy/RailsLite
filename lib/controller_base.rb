require 'activesupport'
require 'activesupport/core_ext'
require 'activesupport/inflector'
require 'erb'

require_relative "session"

module ActiveRecordLite

  class ControllerBase
    attr_reader :params, :session
    attr_reader :req, :res, :built_response

    def initialize(req, res, route_params = {})
      @req = req
      @res = res
      @session = Session.new(req)
    end

    def redirect_to(url)
      if already_built_response?
        raise
      end
      @res["location"] = url
      @res.status = 302
      @built_response = :redirected
    end

    def render(template_name)
      folder_name = "#{self.class}".underscore
      path = "views/#{folder_name}/#{template_name}.html.erb"
      htmls = File.read(path)
      render_content(htmls, "text/html")
      @built_response = :rendered
    end

    def render_content(content, content_type)
      if already_built_response?
        raise
      end
      @res.body = content
      @res.content_type = content_type
      @built_response = content
    end


    private
    def already_built_response?
      !!@built_response
    end


  end
end
