require 'webrick'
require 'json'

require_relative '../lib/controller_base'

server = WEBrick::HTTPServer.new(Port: 3000)

class CatsController < ActiveRecordLite::ControllerBase
end

server.mount_proc("/") do |req, res|

  controller = CatsController.new(req, res)
  res.body = "#{controller.params}"

  # Rendering the request line of the requeset.
  # req_line = req.request_line
  # controller.render_content(req_line, "text/text")

  # Parising the request body.
  # re = /^([^ ]+) ([^ ]+) ([^ ]+)$/
  # res.body = "#{re.match(req_line)[2]}"
end


trap("INT") { server.shutdown }
server.start
