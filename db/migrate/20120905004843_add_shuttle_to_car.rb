class AddShuttleToCar < ActiveRecord::Migration
  def change
    add_column :cars, :shuttle, :boolean, :default => false
  end
end
