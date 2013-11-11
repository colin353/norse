class AddMunicipalIdToPerson < ActiveRecord::Migration
  def change
      add_column :people, :municipal_id, :integer
  end
end
