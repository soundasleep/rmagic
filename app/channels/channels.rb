class Channels

  # TODO move into Channels
  class WrappedChannel
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def needs_update?
      WebsocketRails[name].subscribers.any?
    end

    def update(json)
      WebsocketRails[name].trigger "update", json
    end
  end

  def get_channel(name)
    WrappedChannel.new(name)
  end

  def update_all
    channels.each do |name|
      channel = get_channel("name/#{channel_id}")
      if channel.needs_update?
        method = "#{name}_json"
        channel.update presenter.send(method)
      end
    end
  end

end
