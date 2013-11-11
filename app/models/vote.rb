class Vote < ActiveRecord::Base
  attr_accessible :item_id, :person_id, :vote
  belongs_to :item
  belongs_to :person
end
