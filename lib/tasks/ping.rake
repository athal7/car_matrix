desc "pings my domain"
task :pings do
  require 'net/http'
  require 'uri'
  Net::HTTP.get URI('http://huroncarmatrix.herokuapp.com')
end
