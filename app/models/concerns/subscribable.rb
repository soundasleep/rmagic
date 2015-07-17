module Subscribable
  extend ActiveSupport::Concern

  def trigger_channel_update(source = nil)
    json = self.safe_json
    if source
      json[:source] = source
    end

    # trigger an update on all channels
    WebsocketRails["#{channel_name}/#{id}"].trigger "update", json
  end

  private
    def channel_name
      self.class.name.underscore
    end

end
