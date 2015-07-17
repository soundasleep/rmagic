module Subscribable
  extend ActiveSupport::Concern

  def trigger_channel_update
    channel = get_channel("#{channel_name}/#{id}")
    if channel.needs_update?
      channel.update safe_json
    end
  end

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

  private
    def channel_name
      self.class.name.underscore
    end

end
