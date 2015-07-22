require 'webrick'
require 'json'

require_relative '../lib/controller_base'

server = WEBrick::HTTPServer.new(Port: 3000)

server.mount_proc("/") do |req, res|
  res.content_type = "text/text"
  req_line = req.request_line
  re = /^([^ ]+) ([^ ]+) ([^ ]+)$/
  res.body = "#{re.match(req_line)[2]}"
end


trap("INT") { server.shutdown }

server.start
