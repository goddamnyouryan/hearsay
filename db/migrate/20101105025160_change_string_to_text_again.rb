class ChangeStringToText < ActiveRecord::Migration
  def self.up
  	change_column(:answers, :message, :text, :limit => 2000)
  	change_column(:cats, :message, :text, :limit => 2000)
  	change_column(:comments, :message, :text, :limit => 2000)
  	change_column(:events, :data, :text, :limit => 2000)
  end

  def self.down
  end
end
