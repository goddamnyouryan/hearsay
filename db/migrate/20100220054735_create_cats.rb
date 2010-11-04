class CreateCats < ActiveRecord::Migration
  def self.up
    create_table :cats do |t|
      t.integer :user_id, :null => false
      t.string :message, :null => false
			t.string :state, :default => "private"
      t.timestamps
    end
  end

  def self.down
    drop_table :cats
  end
end
