class AddCounterCacheToAnswers < ActiveRecord::Migration
  def self.up
    add_column :answers, :votes_count, :integer, :default => 0
    Answer.find(:all).each do |s|
    	s.update_attribute :votes_count, s.votes.length
    end
  end

  def self.down
    remove_column :answers, :votes_count
  end
end
