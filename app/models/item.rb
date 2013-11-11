class Item < ActiveRecord::Base
  attr_accessible :committee, :item_number, :result, :title, :vote_date
  
  has_many :votes
  
  def name 
      self.title
  end
  
  def supporters
    # Get a list of supporters of the item.
    list = []
    self.votes.find_all_by_vote("Yes").each do |v|
        list.push v.person
    end
    
    list
  end
  
end
