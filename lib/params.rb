require 'uri'
require 'byebug'

module RailsLite

  class Params

    def initialize(req, routes_params = {})
      @params_data = {}
      @params_data = @params_data.merge(routes_params)
      @params_data = @params_data.merge(parse_query(req.query_string))
      @params_data = @params_data.merge(parse_query(req.body))
    end

    def [](key)
      @params_data[key.to_sym] || @params_data[key.to_s]
    end

    def []=(key, value)
      @params_data[key.to_sym] || @params_data[key.to_s] = value
    end

    def to_s
      @params_data.to_s
    end

    private
    attr_accessor :params_data

    def parse_query(query)
      return {} unless query
      result_hash = Hash.new { |hash, key| hash[key] = {} }
      query_array = URI::decode_www_form(query)

      query_array.each do |k_v_p|
        keys = parse_key(k_v_p.first)
        value = k_v_p.last

        current_hash = result_hash
        keys.each do |key|
          if keys.last == key
            current_hash[key] = value
          else
            current_hash[key] ||= Hash.new { |hash, key| hash[key] = {} }
          end
          current_hash = current_hash[key]
        end
      end

      result_hash
    end

    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end

end
