class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :timezone
      t.integer :max_flight_difference, :default => 30
      t.integer :future_display_dates, :default => 5
      t.integer :past_display_dates, :default => 1
      t.timestamps
    end
    add_column :cars, :project_id, :integer
    add_column :flights, :project_id, :integer
    Project.create!({:name=>"Unity Rochester", :timezone => "-0500"})
    Car.all.each {|car| car.update_attribute(:project_id, Project.first)}
    Flight.all.each {|car| car.update_attribute(:project_id, Project.first)}
  end
end
