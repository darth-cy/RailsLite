require 'webrick'
require 'json'

require_relative '../lib/controller_base'
require_relative '../lib/router.rb'

require_relative '../app/controller/nets_controller.rb'

server = WEBrick::HTTPServer.new(Port: 3000)

class MyRouterClass < RailsLite::Router
  extendable_actions :define
end

server.mount_proc("/") do |req, res|
  router = MyRouterClass.new
  router.draw do
    get Regexp.new("^/nets$"), NetsController, :index
    get Regexp.new("^/nets/(?<id>\\d+)"), NetsController, :show
    get Regexp.new("^/nets/new$"), NetsController, :new
    post Regexp.new("^/nets/(?<id>\\d+)"), NetsController, :create
    get Regexp.new("^/nets/define"), NetsController, :define
  end
  router.run(req, res)

  # render the controller params.
  # controller = NetsController.new(req, res)
  # res.body = "#{controller.params}"

  # Rendering the request line of the requeset.
  # req_line = req.request_line
  # controller = NetsController.new(req, res)
  # controller.render_content(req_line, "text/text")

  # Parising the request body.
  # re = /^([^ ]+) ([^ ]+) ([^ ]+)$/
  # res.body = "#{re.match(req_line)[2]}"
end

trap("INT") { server.shutdown }
server.start
