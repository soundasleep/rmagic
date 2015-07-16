module Subscribable
  extend ActiveSupport::Concern

  included do
    after_update :trigger_update
  end

  def trigger_update
    # trigger an update on all channels
    WebsocketRails["#{channel_name}/#{id}"].trigger "update", self.safe_json
  end

  private
    def channel_name
      self.class.name.underscore
    end

end
