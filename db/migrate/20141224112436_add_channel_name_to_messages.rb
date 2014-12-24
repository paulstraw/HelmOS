class AddChannelNameToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :channel_name, :text
  end
end
