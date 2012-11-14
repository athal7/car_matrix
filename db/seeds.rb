Project.all.each(&:delete)
Car.all.each(&:delete)
Flight.all.each(&:delete)

Project.create({:name => "Unity Rochester", :timezone => "-0500"})
Project.create({:name => "Texas", :timezone => "-0600"})

Project.all.each do |project|
  Car.create({:name => 'Hotel Shuttle', :num_seats => 500, :shuttle => true, :project_id => project.id})
end

colors = ["blue", "red", "green", "orange", "purple", "white", "black", "brown", "silver", "gold", "yellow"]
colors.size.times do |i|
  Car.create({
    :name => "#{colors[i]} car",
    :num_seats => 5,
    :project_id => Project.all.sample.id
  })
end

airlines = ["United", "US Air", "Southwest"]
names = ["Andrew", "Rebecca", "John", "Bob", "Sally"]

30.times do
  car = Car.all.sample
  Flight.create({
    :airline => airlines.sample,
    :car_id => car.id,
    :flight_number => (rand * 1000).to_i,
    :flight_time => DateTime.now + ((rand * 10000) + 1000).minutes,
    :traveler_name => names.sample,
    :project_id => car.project.id
  })

end
