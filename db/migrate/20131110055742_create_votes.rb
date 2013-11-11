class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :person_id
      t.string :vote
      t.integer :item_id

      t.timestamps
    end
  end
end
