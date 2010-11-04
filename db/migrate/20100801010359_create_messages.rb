class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.string :subject
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
