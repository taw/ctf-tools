require "pathname"
Gem::Specification.new do |s|
  s.name         = "ctf-tools"
  s.version      = "0.1.20180429"
  s.date         = "2018-04-29"
  s.summary      = "Collection of functions for CTFs, mostly crypto"
  s.authors      = ["Tomasz Wegrzanowski"]
  s.email        = "Tomasz.Wegrzanowski@gmail.com"
  s.files        = %W[.rspec lib spec README.md].map{|x| Pathname(x).find.to_a.select(&:file?)}.flatten.map(&:to_s)
  s.homepage     = "https://github.com/taw/ctf-tools"
  s.license      = "MIT"
end
