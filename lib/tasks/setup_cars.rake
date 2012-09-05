task :setup_cars => :environment do
  Car.all.each { |car| car.destroy }
  Car.create({:name => 'Hotel Shuttle', :num_seats => 500, :shuttle => true})
  Car.create({:name => 'Car 1', :num_seats => 5})
  Car.create({:name => 'Car 2', :num_seats => 5})
  Car.create({:name => 'Car 3', :num_seats => 5})
  Car.create({:name => 'Car 4', :num_seats => 5})
  Car.create({:name => 'Car 5', :num_seats => 5})
end
