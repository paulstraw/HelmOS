class RemoveMessagableFromMessages < ActiveRecord::Migration
  def change
    remove_reference :messages, :messagable, polymorphic: true, index: true
  end
end
