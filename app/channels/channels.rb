class Channels

  class WrappedChannel
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def needs_update?
      # on Production, we don't have any way to see the subscribers to a channel
      # which is super frustrating and makes things slow
      Rails.env.production? || WebsocketRails[name].subscribers.any?
    end

    def update(json)
      WebsocketRails[name].trigger "update", json
    end
  end

  def get_channel(name)
    WrappedChannel.new(name)
  end

  def private_channels
    []
  end

  def update_all(context)
    channels.each do |name|
      channel = get_channel("#{name}/#{channel_id}")
      if channel.needs_update?
        method = "#{name}_json"
        channel.update presenter.send(method)
      end
    end

    private_channels.each do |name|
      channel = get_channel("#{name}/#{channel_id}/private/#{context.channel_hash}")
      if channel.needs_update?
        method = "#{name}_json"
        channel.update presenter.send(method, context.channel_context)
      end
    end
  end

end
