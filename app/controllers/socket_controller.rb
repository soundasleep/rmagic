class SocketController < WebsocketRails::BaseController
  def connect
    puts "connect (#{message})"

    # TODO remove
    trigger_success({ message: "Yeah" }) # {:message => 'awesome level is sufficient'}
  end
end
