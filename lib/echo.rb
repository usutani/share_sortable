#!/usr/bin/env ruby
require 'rubygems'
require 'em-websocket'

connections = Array.new
prev_msgs = Array.new

EventMachine::WebSocket.start(:host => "0.0.0.0",
                              :port => 8080,
                              :debug => true) do |ws|
  ws.onopen do
    connections.push(ws) unless connections.index(ws)
    prev_msgs.each { |msg| ws.send(msg) } if ARGV[0] == '--cache'
  end

  ws.onmessage do |msg|
    msgs = msg.split(':')

    if msgs[0] != '' && ARGV[0] == '--cache'
      prev_msgs.delete_if { |prev_msg| msg == prev_msg } 
      prev_msgs.push(msg)
    end

    connections.each { |con| con.send(msg) unless con == ws }
  end

  ws.onclose do
    connections.delete_if { |con| con == ws }
  end
end
