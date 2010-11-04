class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.integer :cat_id
      t.integer :user_id
      t.string :message
      t.integer :votes_count, :default => 0
			t.string :state, :default => "unread"
      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
