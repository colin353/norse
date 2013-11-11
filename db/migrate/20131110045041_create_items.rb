class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :item_number
      t.boolean :result
      t.datetime :vote_date
      t.string :committee

      t.timestamps
    end
  end
end
