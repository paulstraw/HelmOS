class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.references :ship, index: true
      t.references :messagable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
