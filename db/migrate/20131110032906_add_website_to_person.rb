class AddWebsiteToPerson < ActiveRecord::Migration
  def change
      add_column :people, :website, 'string'
      add_column :people, :photo, 'string'
  end
end
