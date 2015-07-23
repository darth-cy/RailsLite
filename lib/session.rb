require 'webrick'
require 'json'

module RailsLite

  class Session

    def initialize(req)
      cookie = req.cookies.find{ |ck| ck.name == "_app_lite" }
      if cookie
        @session_data = JSON.parse(cookie.value)
      else
        @session_data = {}
      end
    end

    def [](key)
      @session_data[key.to_sym] || @session_data[key.to_s]
    end

    def []=(key, value)
      @session_data[key.to_s] || @session_data[key.to_sym] = value
    end

    def store_session(res)
      unless @session_data.empty?
        res.cookies << WEBrick::Cookie.new("_app_lite", @session_data.to_json)
      end
    end

    private
    attr_accessor :session_data
  end

end
