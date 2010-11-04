class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :user_id
      t.integer :friend_id
      t.integer :ranks_count, :default => 0
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
			t.string :state, :default => "unread"
      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
