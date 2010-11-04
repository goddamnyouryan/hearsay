class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :user_id
      t.integer :answer_id
      t.string :message
			t.string :state, :default => "unread"
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
