Gem::Specification.new do |s|
  s.name        = "rails_iron"
  s.version     = "0.0.4"
  s.date        = "2013-06-26"
  s.summary     = "RailsIron"
  s.description = "To simplify integrating iron.io into Rails"
  s.authors     = ["H.J. Blok"]
  s.email       = "hj.blok@sudoit.nl"
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = ""
  s.license     = "MIT"
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
end
