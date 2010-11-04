class AddEventIdToDeleteableItems < ActiveRecord::Migration
  def self.up
  	add_column :cats, :event_id, :integer
  	add_column :comments, :event_id, :integer
  	add_column :answers, :event_id, :integer
  end

  def self.down
  end
end
