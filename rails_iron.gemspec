Gem::Specification.new do |s|
  s.name        = "rails_iron"
  s.version     = "0.0.10"
  s.date        = "2014-02-03"
  s.summary     = "RailsIron"
  s.description = "To simplify integrating iron.io into Rails"
  s.authors     = ["H.J. Blok"]
  s.email       = "hj.blok@sudoit.nl"
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = ""
  s.license     = "MIT"
  s.add_runtime_dependency "iron_worker_ng", "~> 1.1"
  s.add_runtime_dependency "typhoeus", "~> 0.6"
  s.add_development_dependency "coveralls"
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "webmock"
end
