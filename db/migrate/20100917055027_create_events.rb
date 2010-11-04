class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :user_id, :null => false
      t.string :kind
      t.string :data

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
