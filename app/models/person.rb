class Person < ActiveRecord::Base
  attr_accessible :name, :title, :municipal_id
  has_many :votes
  
  def voteOn(item)
     # This function returns the person's vote on the given item
     # or nil if there is no recorded vote for them.
     v = self.votes.find_by_item_id item.id
     if !v.nil? 
         return v.vote
     else
         return nil
     end
  end
  
  def absenteeRate
    # This function returns the absentee rate for the person.
    number = self.votes.find_all_by_vote("Absent").count
    total = self.votes.count
    return number.to_f / total.to_f
  end
  
  def similarityTo(person)
      agreement = 0
      count = 0
      Item.all.each do |i|
          x = person.voteOn i
          y = self.voteOn i
          next if x.nil? || y.nil? || x == "Absent" || y == "Absent"
          count += 1
          agreement += 1 if x == y
      end
      return (1.0*agreement) / (1.0 * count)
  end
  
end
