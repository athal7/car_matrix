require 'csv'
require 'date'
require 'time'

desc "uploads old flights"
task :upload_flights => :environment do
  CSV.read("public/flights_to_upload.csv").each do |row|
    flight = {
      :traveler_name => row[0].to_s,
      :flight_time => DateTime.parse(row[1].to_s + "-04:00"),
      :airline => row[2].to_s,
      :flight_number => row[3].to_s
    }
    Flight.create(flight) unless DateTime.parse(row[1].to_s + "-04:00").to_date < Date.today
  end
end
