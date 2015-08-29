# RailsLite

## Summary
RailsLite is a project designed to emulate the behavior of Rails framework. The project defines some of the framework classes including <code>ControllerBase</code>, <code>Router</code> and some other utility classes such as <code>Params</code> and <code>Session</code>.

## How to Use
You can download the repository or clone it. Then, in the app folder, create your own controllers and views by inheriting from the <code>ControllerBase</code> defined in the lib folder.

### Example Controller
```ruby
require_relative '../libs.rb'

class NetsController < RailsLite::ControllerBase

  def index
    @page_title = "Index Page"
    render :index # render defined on ControllerBase
  end

  def show
    @page_title = "Show Page"
    @net_id = params[:id] # params is accessible as a method defined on ControllerBase.
    render :show
  end

  ... # Other controller logic
end
```

## Server Implementation
There is one server instance defined for an application. It is extended from the Router class and defined in <code>bin/server.rb</code>. The Router has a draw function that you can use to extend the routes on the router.

### Extendable Actions
The macro method <code>extendable_actions</code> defines available HTTP protocols that the server may respond to. It creates a function named the same as the protocol method, that can be used to create routes on the method.
```ruby
class Router
  extend RoutesExtendable
  ...

  extendable_actions :get, :post, :put, :delete
  ...
end
```

### Example Server
```ruby
server = WEBrick::HTTPServer.new(Port: 3000) # Use WEBrick as the default server.

class MyRouterClass < RailsLite::Router # Extend Router class
  extendable_actions :define
end

server.mount_proc("/") do |req, res|
  router = MyRouterClass.new
  router.draw do
    get Regexp.new("^/nets$"), NetsController, :index
    get Regexp.new("^/nets/(?<id>\\d+)"), NetsController, :show
    get Regexp.new("^/nets/new$"), NetsController, :new
    post Regexp.new("^/nets$"), NetsController, :create
    get Regexp.new("^/nets/define"), NetsController, :define
  end
  router.run(req, res)
```

## Development Highlights

### Nested Params
To interpret the params, especially the nested ones, I need a method to turn the string representation of the nested data into Ruby objects. To do this, I implemented a recursive scheme to construct nested params.

```ruby
def parse_query(query)
  return {} unless query
  result_hash = Hash.new { |hash, key| hash[key] = {} }
  query_array = URI::decode_www_form(query)

  query_array.each do |key_value_pair|
    keys = parse_key(key_value_pair.first)
    value = key_value_pair.last

    current_hash = result_hash

    keys.each do |key|
      if keys.last == key
        current_hash[key] = value
      else
        current_hash[key] ||= Hash.new { |hash, key| hash[key] = {} } # If there's no such value, create an empty hash to fill the space.
      end
      current_hash = current_hash[key] # Go one level deeper in the hash
    end
  end
```

## Future Development

### Flash
Flash is also an embedded object class in the router class. It has the same level of abstraction with Param and Session class. Also, like Param and Session, it extracts relevant information by exerting action on the req object.
