require 'bundler/inline'
require 'json'

gemfile do
  source 'https://rubygems.org'
  
  gem 'em-websocket'
end

module Myungit
  class ActionUnknown < StandardError; end
  class ActionMissing < StandardError; end
end

puts "Running on 0.0.0.0:8443"

EM.run {
	EM::WebSocket.run(:host => "0.0.0.0", :port => 8443) do |ws|
    path = nil

		ws.onopen { |handshake|
			puts "WebSocket connection open"
			ws.send "Hello Client, you connected to #{handshake.path}"
		}

		ws.onclose { puts "Connection closed" }

		ws.onmessage do |msg|
      json = JSON.parse(msg)

      raise Myungit::ActionMissing unless json['action']
      raise Myungit::ActionUnknown unless ['setRepoPath'].include?(json['action'])

      puts "Previous path = #{path}"

      path = json['path']

      puts "Path is now = #{path}"

      puts "Recieved message: #{json['action']}"
      ws.send "Pong: #{msg}"
    rescue Myungit::ActionMissing => e
      puts "Discarding message because the action is missing: #{msg}"
    rescue Myungit::ActionUnknown => e
      puts "Discarding message because the action doesn't exist: #{msg}"
    rescue JSON::ParserError => e
      puts "Discarding message because it is not JSON: #{msg}"
    end
  end
}
