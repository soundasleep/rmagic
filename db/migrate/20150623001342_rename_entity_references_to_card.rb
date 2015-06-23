class RenameEntityReferencesToCard < ActiveRecord::Migration
  def change
    change_table :action_log_targets do |t|
      t.rename :entity_id, :card_id
    end
    change_table :action_logs do |t|
      t.rename :entity_id, :card_id
      t.rename :entity_action, :card_action
    end
    change_table :battlefields do |t|
      t.rename :entity_id, :card_id
    end
    change_table :decks do |t|
      t.rename :entity_id, :card_id
    end
    change_table :declared_attackers do |t|
      t.rename :entity_id, :card_id
    end
    change_table :graveyards do |t|
      t.rename :entity_id, :card_id
    end
    change_table :hands do |t|
      t.rename :entity_id, :card_id
    end
  end
end
