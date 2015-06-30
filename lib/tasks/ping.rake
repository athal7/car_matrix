desc "pings my domain"
task :pings do
  require 'net/http'
  require 'uri'
  Net::HTTP.get URI(ENV['car_matrix_url'])
end
