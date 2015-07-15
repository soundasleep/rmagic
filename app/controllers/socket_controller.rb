class SocketController < WebsocketRails::BaseController
  def connect
    puts "connect (#{message})"
  end
end
