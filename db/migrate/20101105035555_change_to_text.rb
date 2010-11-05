class ChangeToText < ActiveRecord::Migration
  def self.up
  	change_column(:answers, :message, :text)
  	change_column(:cats, :message, :text)
  	change_column(:comments, :message, :text)
  	change_column(:events, :data, :text)
  end

  def self.down
  end
end
